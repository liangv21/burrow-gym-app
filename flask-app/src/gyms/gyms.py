from flask import Blueprint, request, jsonify, make_response
import json
from src import db

gyms = Blueprint('gyms', __name__)

