from flask import Flask


def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'DSDLFSKDFKSK KSDFSKFLKSK LSKDFKJS'
    
    #import views and auths classes from view and auth files respectively
    from .view import views
    from .auth import auths
    
    #register the blueprints, passing teh classes and url_prefix as parameters
    app.register_blueprint(views, url_prefix='/')
    app.register_blueprint(auths, url_prefix='/')
    return app