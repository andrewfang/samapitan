__author__ = "timon"

import requests
import json

database = "https://samapitan.firebaseio.com/"

# Apple HQ
gps_location = (37.333554, -122.033737)
# Stanford d.school
# gps_location = (37.426448, -122.172047)

interests_dict = [
    {
    "description" : "HQ for DTL until June 2016. Come here if you help coordinating volunteer efforts. We also have free WiFi ;-)",
    "lat" : 0.0035,
    "long" : 0.0015,
    "photoUrl" : "http://disastertechlab.org/wp-content/uploads/2015/02/Disaster-Tech-Lab-Logo-web_smallest.png",
    "title" : "Disaster Tech Lab HQ"
    },
    {
    "description" : "The Ellinikon Warehouse. Open from 9am-6pm. Help to sort through donations is always neede =)",
    "lat" : 0.005,
    "long" : -0.005,
    "photoUrl" : "http://billandcher.com/images/athens-revisited/140618x4660.jpg",
    "title" : "Ellinikon Warehouse"
    },
    {
    "description" : "Hey, if you know refugees who need shelter, some locals set up a couple of tents as temporary shelter for refugees. There is capacity for about 10 more.",
    "lat" : -0.009,
    "long" : 0.02,
    "photoUrl" : "https://static-secure.guim.co.uk/sys-images/Guardian/About/General/2012/12/6/1354807819786/Dadaab-refugee-camp-Kenya-008.jpg",
    "title" : "Temporary Accomodation for Refugees"
    },
]
people_dict = [
    {
    "bio" : "I am CPR certified and speak a little bit of greek.",
    "group" : "Lifeguard Hellas",
    "imageUrl" : "https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/1172729_144412765768915_1014422129_o.jpg",
    "lat" : 0,
    "long" : 0.009,
    "name" : "Devin"
    },
    {
    "bio" : "I am a lifeguard volunteering at Lifeguard Hellas and do first-aid for refugees arriving on boats",
    "group" : "Lifeguard Hellas",
    "imageUrl" : "https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/914110_10200199659688352_1191794748_o.jpg",
    "lat" : 0.007,
    "long" : 0.003,
    "name" : "Vicky"
    },
    {
    "bio" : "Hey there, I just got here a week ago and would love to help with anything!",
    "group" : "Women's Shelter",
    "imageUrl" : "https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/11953553_10207430399777635_3795358292141619737_o.jpg",
    "lat" : -0.007,
    "long" : -0.01,
    "name" : "Aitran"
    },
    {
    "bio" : "I am a doctor at MSF. Give me a shoutout if I am nearby and you need medical assistance.",
    "group" : "MSF",
    "imageUrl" : "https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/12605448_10208296216823986_798303132874935139_o.jpg",
    "lat" : 0.01,
    "long" : -0.007,
    "name" : "Anton"
    },
    {
    "bio" : "Hey this is Sumita from Are You Syrious. We provide shelter for refugees. I speak some Arabic, if you need a translator.",
    "group" : "Are You Syrious",
    "imageUrl" : "https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/12901049_10154122449206967_3960539456029988429_o.jpg",
    "lat" : -0.007,
    "long" : 0.004,
    "name" : "Sumita"
    },
    {
    "bio" : "Howdy, I'm Ramin. I've been overseeing the volunteer coordination of Caritas Hellas in the area for the last two months.",
    "group" : "Caritas Hellas",
    "imageUrl" : "https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/1262656_10151618835302050_523574602_o.jpg",
    "lat" : 0.03,
    "long" : 0.03,
    "name" : "Ramin"
    },
]
requests_dict = [
    {
    "chat" : [ {
      "owner" : "NotMe",
      "ownerName" : "Anton",
      "text" : "A refugee family of 5 here in the camp are in dire need of shoes for their 3 children. One of their boys already cut their heel this morning while playing bare-footed. Size 7, 8, 8 and 10"
    }, {
      "owner" : "Joined",
      "ownerName" : "Devin",
      "text" : "Devin joined the chat."
    }, {
      "owner" : "NotMe",
      "ownerName" : "Devin",
        "text" : "Anton, I have two pairs (size 8 and 10) lying right next to me! I can bring them over right now."
    }, {
      "owner" : "NotMe",
      "ownerName" : "Anton",
      "text" : "That's amazing Devin."
    }, {
      "owner" : "NotMe",
      "ownerName" : "Anton",
      "text" : "That means we only need 2 more pairs (size 7 and 8) - i just updated the description too."
    } ],
        "description" : "A refugee family of 5 here in the camp are in dire need of shoes for their 3 children. One of their boys already cut their heel this morning while playing bare-footed.   UPDATE: Only 2 more pairs needed (Size 7 and 8) ",
    "lat" : 0.02,
    "long" : 0.0009,
    "members" : [
        {
      "group" : "Lifeguard Hellas",
      "imageUrl" : "https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/1172729_144412765768915_1014422129_o.jpg",
      "name" : "Devin"
        },
    ],
    "time" : "10:11",
    "title" : "Children shoes needed",
    "urgency" : 0
    },
    {
    "chat" : [ {
      "owner" : "NotMe",
      "ownerName" : "Timon",
      "text" : "Hey, I just met a refugee from Syria, but don't understand what he is trying to tell me. He seems to need help urgently!"
    }, {
      "owner" : "Joined",
      "ownerName" : "Sumita",
      "text" : "Sumita joined the chat."
    }, {
      "owner" : "NotMe",
      "ownerName" : "Sumita",
        "text" : "Ramin, I can't come over right now, but if you call me on my phone I can remote-translate for you :)"
    } ],
    "description" : "Hey, I just met a refugee from Syria, but don't understand what he is trying to tell me. He seems to need help urgently!",
    "lat" : -0.003,
    "long" : -0.001,
    "members" : [ {
      "group" : "Are You Syrious",
      "imageUrl" : "https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/12901049_10154122449206967_3960539456029988429_o.jpg",
      "name" : "Sumita"
    } ],
    "time" : "13:37",
    "title" : "Translator needed - Arabic",
    "urgency" : 1
    },
    {
    "chat" : [ {
      "owner" : "NotMe",
      "ownerName" : "Aitran",
      "text" : "Hey everyone, I just arrived today and am still getting oriented. Does anyone want to grab lunch or dinner and give me a quick run-trough of the refugee situation here?"
    }, {
      "owner" : "Joined",
      "ownerName" : "Ramin",
      "text" : "Ramin joined the chat."
    }, {
      "owner" : "Joined",
      "ownerName" : "Vicky",
      "text" : "Vicky joined the chat."
    }, {
      "owner" : "NotMe",
      "ownerName" : "Vicky",
        "text" : "Welcome Aitran! Are you free tonight? I know a really good Gyros that is close by that we could go to!"
    }, {
      "owner" : "NotMe",
      "ownerName" : "Ramin",
      "text" : "If you're talking about GyroScope, I'm definitely coming too! ;-)"
    } ],
    "description" : "Hey everyone, I just arrived today and am still getting oriented. Does anyone want to grab lunch or dinner and give me a quick run-trough of the refugee situation here?Hey, I just met a refugee from Syria, but don't understand what he is trying to tell me. He seems to need help urgently!",
    "lat" : 0.01,
    "long" : 0.0,
    "members" : [
        {
      "group" : "Caritas Hellas",
      "imageUrl" : "https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/1262656_10151618835302050_523574602_o.jpg",
      "name" : "Ramin"
        },
        {
      "group" : "Lifeguard Hellas",
      "imageUrl" : "https://scontent-sjc2-1.xx.fbcdn.net/t31.0-8/914110_10200199659688352_1191794748_o.jpg",
      "name" : "Vicky"
        },
    ],
    "time" : "15:22",
    "title" : "New in town - Lunch?",
    "urgency" : 0
    },
]

def populate_with_gps(data):
    """Place data around every gps location defined above"""
    result = []
    lat, lon = gps_location
    for datum in data:
        new_datum = datum.copy()
        new_datum['lat'] = lat + datum['lat']
        new_datum['long'] = lon + datum['long']
        result.append(new_datum)
    return result



def delete_request(name):
    r = requests.delete(database + name + ".json")
    print "Status: %d" % r.status_code
    print r.reason
    print r.text

def put_request(name, data):
    r = requests.put(database + name + ".json", data=json.dumps(data))
    print "Status: %d" % r.status_code
    print r.reason
    print r.text

def main():
    print "Cleaning up..."
    delete_request("interests")
    delete_request("people")
    delete_request("requests")

    all_interests = populate_with_gps(interests_dict)
    all_people = populate_with_gps(people_dict)
    all_requests = populate_with_gps(requests_dict)

    print "Adding to database..."
    put_request("interests", all_interests)
    put_request("people", all_people)
    put_request("requests", all_requests)

if __name__ == "__main__":
    main()

