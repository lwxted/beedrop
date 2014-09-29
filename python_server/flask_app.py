from flask import Flask, request, jsonify
from random import randint
app = Flask(__name__)

# Three in-memory database: user profile, transaction profile, and inverted loc to find user
personDB = {} # Index by user ID
transDB = {} # Index by trans ID
locToUserDB = {} # Index by X coord

#distThreshold = 0.01 # degree
distThreshold = 1000 # degree

class Person:
    def __init__(self, ID, curLoc, name, bUser):
        self.ID = ID
        self.curLoc = curLoc
        self.name = name
        self.bUser = bUser
        self.devRequest = 0
    def set_delivery_req(self, devRequest):
        self.devRequest = devRequest

class DeliveryRequest:
    def __init__(self):
        self.userID = -1
        self.driverID = -1
        self.fromLoc = 0
        self.toLoc = 0
        self.requestProduct = 0
        self.payment = 0
        self.passcode = 0
        self.isSentOutToDriver = False
        self.isAcceptedByDriver = False
    def selectDriver(self, driverID):
        self.driverID = driverID
        self.isSentOutToDriver = True
        print 'selectDriver %d' % driverID

@app.route('/')
def hello_world():
    return 'Hello World!'

# Get the user info
@app.route('/addPerson', methods=['POST'])
def addUser():
    j_data = request.get_json()
    print 'addPerson:',
    print j_data
    ID = j_data['ID']
    curLoc = j_data['curLoc']
    name  = j_data['name']
    bUser = j_data['bUser']
    # Update the database
    personDB[ID] = Person(ID, curLoc, name, bUser)
    # Add to locToUserDB based on X coord
    x_coord = curLoc[0]
    if not x_coord in locToUserDB:
        locToUserDB[x_coord] = []
    locToUserDB[x_coord].append(ID)
    success = {"status": 0}
    return jsonify(**success)

@app.route('/submitUserDeliveryForm', methods=['POST'])
def submitForm():
    j_data = request.get_json()
    print 'submit form:',
    print j_data
    ID = j_data['ID']
    p_data = personDB[ID]
    devReq = DeliveryRequest()
    devReq.userID = j_data['ID']
    devReq.fromLoc = j_data['fromLoc']
    devReq.toLoc = j_data['toLoc']
    devReq.requestProduct = j_data['requestProduct']
    devReq.payment = j_data['payment']
    devReq.passcode = j_data['passcode']
    p_data.set_delivery_req(devReq)
    success = {"status": 0}
    return jsonify(**success)

# List drivers
@app.route('/listNearbyDrivers', methods=['POST'])
def listDrivers():
    j_data = request.get_json()
    print 'listDrivers:',
    print j_data
    ID = j_data['ID']
    p_data = personDB[ID]
    # Check if delivery exists
    if p_data.devRequest == 0:
        empty_list = {}
        return jsonify(empty_list)
    p_dev_req_fLoc = p_data.devRequest.fromLoc
    driver_list = findMatchForRequest(p_dev_req_fLoc)
    print driver_list
    return jsonify(driver_list)

# Location-based match using 'From' location
# @return a list of driver IDs
def findMatchForRequest(fromLoc):
    reqX = fromLoc[0]
    reqY = fromLoc[1]

    print 'FindMatch using (%f, %f)' % (reqX, reqY)
    # A list of close by drivers within a square bounding box
    allPotentialDrivers = {}
    for x_coord in locToUserDB:
        x_dist = abs(reqX-x_coord)
        if x_dist <= distThreshold:
           id_list = locToUserDB[x_coord]
           for ID in id_list:
               driver = personDB[ID]
               # Driver only
               if not driver.bUser:
                   # Satisfy Y as well
                   y_coord = driver.curLoc[1]
                   y_dist = abs(reqY-y_coord)
                   if y_dist <= distThreshold:
                       allPotentialDrivers[ID] = {"name": driver.name, "rating": randint(0,5)}
    return allPotentialDrivers

@app.route('/selectDriver', methods=['POST'])
def selectDriver():
    j_data = request.get_json()
    print 'selectDriver:',
    print j_data
    userID = j_data['userID']
    driverID = j_data['driverID']
    p_data = personDB[userID]
    p_data.devRequest.selectDriver(driverID)
    success = {"status": 0}
    return jsonify(**success)

@app.route('/pollUserRequest', methods=['POST'])
def pollUserRequest():
    j_data = request.get_json()
    print 'pollUserRequest:',
    print 'remote IP address:' + str(request.remote_addr)
    print j_data
    driverID = j_data['driverID']
    ### BRUTE FORCE SEARCH ###
    response = {"status": -1}
    # Go through all users to check isSentOutToDriver
    for uid in personDB:
        p_data = personDB[uid]
        if p_data.devRequest == 0:
            continue
        p_devReq = p_data.devRequest
        # Some users have no delivery requests
        if p_devReq == 0:
            continue
        if p_devReq.driverID == driverID and p_devReq.isSentOutToDriver and not p_devReq.isAcceptedByDriver:
            response['status'] = 0
            response['userName'] = p_data.name
            response['userID'] = p_devReq.userID
            response['payment'] = p_devReq.payment
            response['passcode'] = p_devReq.passcode
            response['fromLoc'] = p_devReq.fromLoc
            response['toLoc'] = p_devReq.toLoc
            response['requestProduct'] = p_devReq.requestProduct
    return jsonify(**response)

@app.route('/driverAcceptRequest', methods=['POST'])
def driverAccept():
    j_data = request.get_json()
    print 'driverAcceptRequest:',
    print j_data
    userID = j_data['userID']
    p_data = personDB[userID]
    p_devReq = p_data.devRequest
    p_devReq.isAcceptedByDriver = True
    success = {"status": 0}
    return jsonify(**success)

@app.route('/pollDriverAck', methods=['POST'])
def pollDriverAck():
    j_data = request.get_json()
    print 'pollDriverAck:',
    print j_data
    userID = j_data['userID']
    p_data = personDB[userID]
    p_devReq = p_data.devRequest
    success = {"status": -1}
    if p_devReq.isAcceptedByDriver:
        success = {"status": 0}
    return jsonify(**success)

@app.route('/clearAllDatabase', methods=['POST'])
def clearDB():
    personDB = {}
    transDB = {}
    locToUserDB = {}
    success = {"status": 0}
    return jsonify(**success)

if __name__ == '__main__':
    app.debug=True
    app.run(host='0.0.0.0')
