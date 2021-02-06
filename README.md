# Everchords

[![Everchords](https://circleci.com/gh/Dahie/everchords.svg?style=svg)](https://circleci.com/gh/Dahie/everchords) [![Maintainability](https://api.codeclimate.com/v1/badges/97a0c493919fed1be834/maintainability)](https://codeclimate.com/github/Dahie/everchords/maintainability)

Everchords is a tool that connects to Evernote to fetch notes containing songs written in SongPro syntax. Everchords can display these songs beautifully.

# Setup

## Pre-requisites

You need an Evernote-Account and get an API token to use this app.

The app let's you select a Notebook from your Account holding song notes.

Generate your secrets like with any other Rails app.

Setup your evernote credentials.

    cp config/evernote_example.yml config/evernote.yml

Copies the configuration, you have to add your credentials here.
