import os
from flask import Flask

# Flask constructor takes the name of current module (__name__) as argument.
app = Flask(__name__)

#color = os.environ.get('APP_COLOR')
color = "red"

# The route() function of the Flask class is a decorator which tells the application which URL should call the associated function.
@app.route('/')
# ‘/’ URL is bound with hello_world() function.
def main():
  print(color, "Hello World")
	return render_template("hello.html", color=color)

# main
if __name__ == '__main__':
	# run() method of Flask class runs the application on the local development server.
	app.run(host="0.0.0.0", port="8080")

