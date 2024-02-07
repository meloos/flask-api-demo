from flask import Flask, jsonify
from lxml import etree

import os


xml_data = """
<jobs>
    <company>
        <name>Straal</name>
        <job>Cloud / DevOps Engineer</job>
    </company>
</jobs>
"""


app = Flask(__name__)

SOME_SECRET = os.environ["VERY_SECRET_SECRET"]

@app.route("/")
def jobs():

    root = etree.fromstring(xml_data)

    jobs = [{"company": company.find("name").text, "job": company.find("job").text} for company in root.findall("company")]

    return jsonify(jobs)

@app.route("/secret")
def secret():
    return SOME_SECRET