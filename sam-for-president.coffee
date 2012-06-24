#!/usr/bin/env coffee
http = require 'http'
url = require 'url'

BOTS = [
  'http://sambot001.herokuapp.com/vote-sam',
  'http://sambot002.herokuapp.com/vote-sam',
  'http://sambot003.herokuapp.com/vote-sam',
  'http://sambot004.herokuapp.com/vote-sam',
  'http://sambot005.herokuapp.com/vote-sam',
  'http://sambot006.herokuapp.com/vote-sam',
  'http://sambot007.herokuapp.com/vote-sam',
  'http://sambot008.herokuapp.com/vote-sam',
  'http://sambot009.herokuapp.com/vote-sam',
  'http://sambot010.herokuapp.com/vote-sam'
]

VOTES_PER_MINUTE = 10

vote = (id) ->
  bot_index = Math.floor((BOTS.length - 1) * Math.random())
  bot = BOTS[bot_index]
  console.log "#{id} voting with #{bot}"
  try
    http.get url.parse(bot), (res) ->
      response = "#{id} says: "
      res.on 'data', (chunk) ->
        response = response + chunk
      res.on 'end', ->
        console.log response
  catch error
    console.log "#{id} failed to vote", error

scheduleVote = (id) ->
  time_to_vote = 60 * 1000 * Math.random()
  console.log "#{id} voting in #{time_to_vote / 1000} seconds"
  setTimeout ->
    vote id
  , time_to_vote

for i in [1..VOTES_PER_MINUTE]
  do (i) ->
    setInterval ->
      scheduleVote "Voter #{i}"
    , 60 * 1000
