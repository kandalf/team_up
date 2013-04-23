TeamUp
======

Agile standups tracking tool

Allowed Organizations
======= =============

Users will be allowed to login only if belongs to the allowed organizations
listed on the environment variable TEAM_UP_ORGS. Organizations should be
separated by a whitespace.
So for start the server use something like:

TEAM_UP_ORGS="my_org another_org" shotgun
