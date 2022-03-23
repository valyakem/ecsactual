from flask import Blueprint

auths = Blueprint('auths', __name__)

@auths.route('/login')
def login():
    return "<p>Login</p>"

@auths.route('/logout')
def logout():
    return "<p>Logout</p>"

@auths.route('/sign-up')
def sign_up():
    return "<p>Sign Up</p>"