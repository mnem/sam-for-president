#!/usr/bin/env coffee
http = require 'http'
url = require 'url'

BOTS = [
  'http://sambot001.herokuapp.com/vote/',
  'http://sambot002.herokuapp.com/vote/',
  'http://sambot003.herokuapp.com/vote/',
  'http://sambot004.herokuapp.com/vote/',
  'http://sambot005.herokuapp.com/vote/',
  'http://sambot006.herokuapp.com/vote/',
  'http://sambot007.herokuapp.com/vote/',
  'http://sambot008.herokuapp.com/vote/',
  'http://sambot009.herokuapp.com/vote/',
  'http://sambot010.herokuapp.com/vote/'
]

pick_bot = ->
  bot_index = Math.floor((BOTS.length - 1) * Math.random())
  BOTS[bot_index]

vote = (voter_id, candidate) ->
  bot = pick_bot()
  console.log "#{voter_id} voting with #{bot}"

  http.get url.parse("bot#{candidate}"), (res) ->
    response = "#{voter_id} says: "
    res.on 'data', (chunk) ->
      response = response + chunk
    res.on 'error', (error) ->
      console.log "#{voter_id} failed to vote", error
    res.on 'end', ->
      console.log response
  .on 'error', (error) ->
    console.log "#{voter_id} failed to vote", error

scheduleVote = (voter_id, candidate, period) ->
  time_to_vote = period * 1000 * Math.random()
  console.log "#{voter_id} voting in #{time_to_vote / 1000} seconds"
  setTimeout ->
    vote voter_id, candidate
  , time_to_vote

start_votenet = (candidate, period, votes_per_period) ->
  console.log "Voting for '#{candidate}' #{votes_per_period} times per #{period} seconds"
  for i in [1..votes_per_period]
    do (i) ->
      # Schedule now
      scheduleVote "Voter #{i} for #{candidate}", candidate, period
      # And forever
      setInterval ->
        scheduleVote "Voter #{i} for #{candidate}", candidate, period
      , period * 1000

# Sam
start_votenet '2102', 60, 5
