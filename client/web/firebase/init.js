// firebase/init.js
const firebaseConfig = {
  apiKey: "AIzaSyCU0PcgMNtoBjLKYWHPC9sMF3Vap9-Yb8Y",
  appId: "1:216107978984:web:2d8910c57ae490f11a795d",
  messagingSenderId: "216107978984",
  projectId: "nextflix-1b121",
  authDomain: "nextflix-1b121.firebaseapp.com",
  storageBucket: "nextflix-1b121.appspot.com",
  databaseURL: "https://nextflix-1b121-default-rtdb.firebaseio.com"
};

firebase.initializeApp(firebaseConfig);
const db = firebase.database();
