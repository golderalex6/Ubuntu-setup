#!/bin/bash

cd {{cookiecutter.project_name}}

cd backend

uv init

uv add django djangorestframework

rm *.py

direnv allow

django-admin startproject main .
