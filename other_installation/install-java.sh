#!/usr/bin/env bash -l

# sdk list java
sdk install java 11.0.23-tem
sdk install java 17.0.11-tem

# sdk list maven
sdk install maven 3.8.1

# Chose to make a given version the default
sdk default java 17.0.11-tem
sdk default maven 3.8.1
