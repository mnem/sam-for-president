#!/bin/bash
heroku apps:create sambot002 --remote sambot002
git push sambot002 master
heroku ps:scale web=1 --app sambot002

heroku apps:create sambot003 --remote sambot003
git push sambot003 master
heroku ps:scale web=1 --app sambot003

heroku apps:create sambot004 --remote sambot004
git push sambot004 master
heroku ps:scale web=1 --app sambot004

heroku apps:create sambot005 --remote sambot005
git push sambot005 master
heroku ps:scale web=1 --app sambot005

heroku apps:create sambot006 --remote sambot006
git push sambot006 master
heroku ps:scale web=1 --app sambot006

heroku apps:create sambot007 --remote sambot007
git push sambot007 master
heroku ps:scale web=1 --app sambot007

heroku apps:create sambot008 --remote sambot008
git push sambot008 master
heroku ps:scale web=1 --app sambot008

heroku apps:create sambot009 --remote sambot009
git push sambot009 master
heroku ps:scale web=1 --app sambot009

heroku apps:create sambot010 --remote sambot010
git push sambot010 master
heroku ps:scale web=1 --app sambot010
