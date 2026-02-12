#!/bin/bash

WS=$(aerospace list-workspaces --monitor 1 --empty | head -n 1)
aerospace move-node-to-workspace $WS
aerospace workspace $WS

