#!/usr/bin/env coffee
http = require 'http'
url = require 'url'
colors = require 'colors'

CANDIDATES = [
  { id:'2079', period:30, votes:12, name:'Max Aus Ulm' },
  { id:'2102', period:30, votes:11, name:'Sam' },
  { id:'2078', period:30, votes:10, name:'Beverly' },
  { id:'2072', period:30, votes: 9, name:'Simba' },
  { id:'2041', period:30, votes: 8, name:'Ginger and Jeb' },
  { id:'2031', period:30, votes: 7, name:'Bauer' },
  { id:'2075', period:30, votes: 6, name:'Timmy' },
  { id:'2034', period:30, votes: 5, name:'Dixie Bug' },
  { id:'2200', period:30, votes: 4, name:'Brulee' },
  { id:'2042', period:30, votes: 3, name:'Chyna & Sabra' },
  { id:'2024', period:30, votes: 2, name:'Abbey' }
]

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
  bot = "#{pick_bot()}#{candidate}"
  console.log "#{voter_id} voting with #{bot}"
  http.get url.parse(bot), (res) ->
    response = ""
    res.on 'data', (chunk) ->
      response = response + chunk
    res.on 'error', (error) ->
      console.log "#{voter_id} " + "failed to vote".inverse.red, error
    res.on 'end', ->
      console.log "#{voter_id} says: #{response.rainbow}"
  .on 'error', (error) ->
    console.log "#{voter_id} " + "failed to vote".inverse.red, error

scheduleVote = (voter_id, candidate, period) ->
  time_to_vote = period * 1000 * Math.random()
  console.log "#{voter_id} voting in #{Number(time_to_vote / 1000).toPrecision(2)} seconds"
  setTimeout ->
    vote voter_id, candidate
  , time_to_vote

start_votenet = (candidate, period, votes_per_period, name) ->
  console.log "Voting for '#{name.blue.inverse}' #{votes_per_period} times per #{period} seconds"
  for i in [1..votes_per_period]
    do (i) ->
      # Schedule now
      scheduleVote "Voter #{i} for #{name.blue} (#{candidate})", candidate, period
      # And forever
      setInterval ->
        scheduleVote "Voter #{i} for #{name.blue} (#{candidate})", candidate, period
      , period * 1000

start_votenet c.id, c.period, c.votes, c.name for c in CANDIDATES
