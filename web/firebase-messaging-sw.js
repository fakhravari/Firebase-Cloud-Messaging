importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: 'AIzaSyBTg_BCKGPE_1O-gvP4B0iyrHWL17tu_PE',
    appId: '1:870635139547:web:4c18a513418503b6ddb7fe',
    messagingSenderId: '870635139547',
    projectId: 'pushtest-c61f0',
    authDomain: 'pushtest-c61f0.firebaseapp.com',
    storageBucket: 'pushtest-c61f0.appspot.com',
    measurementId: 'G-8C30CPBV8Z',
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});