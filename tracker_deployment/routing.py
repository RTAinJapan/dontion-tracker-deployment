from channels.auth import AuthMiddlewareStack
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.security.websocket import AllowedHostsOriginValidator
import django
from django.urls import path
import os

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'tracker_deployment.settings')

django.setup()

import tracker.routing

application = ProtocolTypeRouter({
    'websocket': AllowedHostsOriginValidator(
        AuthMiddlewareStack(
            URLRouter(
                [path('', URLRouter(tracker.routing.websocket_urlpatterns))]
            )
        )
    ),
})