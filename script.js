const canvas = document.getElementById("particle-background");
const ctx = canvas.getContext("2d");

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

let particles = [];

window.addEventListener("resize", () => {
  canvas.width = window.innerWidth;
  canvas.height = window.innerHeight;
});

class Particle {
  constructor() {
    this.x = Math.random() * canvas.width;
    this.y = Math.random() * canvas.height;
    this.size = Math.random() * 3;
    this.speedX = Math.random() - 0.5;
    this.speedY = Math.random() - 0.5;
    this.color = Math.random() > 0.5 ? "#00f2ff" : "#bc13fe";
  }

  update() {
    this.x += this.speedX;
    this.y += this.speedY;

    if (this.x > canvas.width) this.x = 0;
    if (this.x < 0) this.x = canvas.width;

    if (this.y > canvas.height) this.y = 0;
    if (this.y < 0) this.y = canvas.height;
  }

  draw() {
    ctx.fillStyle = this.color;
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
    ctx.fill();
  }
}

function initParticles() {
  particles = [];

  for (let i = 0; i < 100; i++) {
    particles.push(new Particle());
  }
}

function animateParticles() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  particles.forEach((particle) => {
    particle.update();
    particle.draw();
  });

  requestAnimationFrame(animateParticles);
}

initParticles();
animateParticles();

const cursor = document.getElementById("custom-cursor");

document.addEventListener("mousemove", (e) => {
  cursor.style.left = e.clientX + "px";
  cursor.style.top = e.clientY + "px";
});

const revealItems = document.querySelectorAll(".reveal");

const observer = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add("active");
    }
  });
});

revealItems.forEach((item) => {
  observer.observe(item);
});

const numbers = document.querySelectorAll(".metric-num");

numbers.forEach((num) => {
  const updateCount = () => {
    const target = +num.getAttribute("data-val");
    const current = +num.innerText;

    const increment = target / 100;

    if (current < target) {
      num.innerText = Math.ceil(current + increment);
      setTimeout(updateCount, 20);
    } else {
      num.innerText = target;
    }
  };

  updateCount();
});

const form = document.getElementById("ethio-form");

form.addEventListener("submit", (e) => {
  e.preventDefault();

  const button = form.querySelector(".submit-glow");

  button.innerText = "CONNECTED";

  setTimeout(() => {
    button.innerText = "Send Transmission";
    form.reset();
  }, 2000);
});
function recommendMusic() {
  const mood = document.getElementById("mood").value;
  const result = document.getElementById("recommendResult");

  if (mood === "energetic") {
    result.innerHTML = "🔥 Recommended: Ethio Future Beat";
  } else if (mood === "calm") {
    result.innerHTML = "🌙 Recommended: Addis Night Dreams";
  } else if (mood === "traditional") {
    result.innerHTML = "🎻 Recommended: Ancient Abyssinia";
  } else {
    result.innerHTML = "🚀 Recommended: Cyber Addis 2099";
  }
}
let favorites = [];

function addFavorite(songName) {
  if (!favorites.includes(songName)) {
    favorites.push(songName);

    document.getElementById("favoriteList").innerHTML = favorites
      .map((song) => `<li>${song}</li>`)
      .join("");
  }
}

function searchSongs() {
  let input =
    document.getElementById("searchInput").value.toLowerCase();

  let cards =
    document.querySelectorAll(".searchable");

  cards.forEach(card => {
    let text = card.innerText.toLowerCase();

    if (text.includes(input)) {
      card.style.display = "block";
    } else {
      card.style.display = "none";
    }
  });
}
function signupUser() {

  let email =
    document.getElementById("signupEmail").value;

  let password =
    document.getElementById("signupPassword").value;

  localStorage.setItem("userEmail", email);
  localStorage.setItem("userPassword", password);

  document.getElementById("signupMessage").innerHTML =
    "✅ Account Created!";
}

function loginUser() {

  let email =
    document.getElementById("loginEmail").value;

  let password =
    document.getElementById("loginPassword").value;

  let savedEmail =
    localStorage.getItem("userEmail");

  let savedPassword =
    localStorage.getItem("userPassword");

  if(email === savedEmail &&
     password === savedPassword) {

    document.getElementById("loginMessage").innerHTML =
      "✅ Login Successful";

    document.getElementById("userEmail").innerHTML =
      email;

    document.getElementById("userPanel").style.display =
      "block";

    document.getElementById("loginEmail").style.display =
      "none";

    document.getElementById("loginPassword").style.display =
      "none";

  } else {

    document.getElementById("loginMessage").innerHTML =
      "❌ Wrong Email or Password";
  }
}

function logoutUser() {

  document.getElementById("userPanel").style.display =
    "none";

  document.getElementById("loginEmail").style.display =
    "block";

  document.getElementById("loginPassword").style.display =
    "block";

  document.getElementById("loginMessage").innerHTML =
    "Logged Out";
}
function followArtist() {

  let current =
    Number(
      document.getElementById("followers")
      .innerText
    );

  current++;

  document.getElementById("followers")
    .innerText = current;
}
function playSong(songUrl){
    let player = document.getElementById("audioPlayer");
    player.src = songUrl;
    player.play();
}
function generateMusicIdea() {

  const prompt =
    document.getElementById("promptInput").value;

  const result =
    document.getElementById("generatedResult");

  if (prompt === "") {
    result.innerHTML =
      "Please enter a music idea.";
    return;
  }

  result.innerHTML =
    "🎶 Generated Concept:<br><br>" +
    "Genre: " + prompt +
    "<br><br>" +
    "Mood: Futuristic Ethiopian Vibes" +
    "<br><br>" +
    "Tempo: 128 BPM" +
    "<br><br>" +
    "Instruments: Krar, Synths, AI Drums";
}
function registerUser() {

  const username =
    document.getElementById("username").value;

  document.getElementById("authResult").innerHTML =
    "✅ Account created for " + username;
}

function loginUser() {

  const username =
    document.getElementById("username").value;

  document.getElementById("authResult").innerHTML =
    "🎉 Welcome back " + username;
}
function processPayment() {
  const name =
    document.getElementById("cardName").value;

  document.getElementById("paymentResult").innerHTML =
    "✅ Payment successful! Welcome " + name;
}
function updateProfile(){

const name =
document.getElementById(
"profileInput"
).value;

document.getElementById(
"profileName"
).innerHTML = name;

document.getElementById(
"profileStatus"
).innerHTML =
"🎵 Ethio AI Member";

}
function addFavoriteSong() {

  const song =
    document.getElementById("favoriteSong").value;

  if(song === "") return;

  const li =
    document.createElement("li");

  li.innerHTML = "🎵 " + song;

  document
    .getElementById("playlist")
    .appendChild(li);

  document
    .getElementById("favoriteSong")
    .value = "";
}
function uploadMusic() {

  const title =
    document.getElementById("songTitle").value;

  const file =
    document.getElementById("songFile").files[0];

  if (!title || !file) {

    document.getElementById(
      "uploadResult"
    ).innerHTML =
      "❌ Enter title and choose a file";

    return;
  }

  document.getElementById(
    "uploadResult"
  ).innerHTML =
    "✅ Uploaded: " + title;
}
function addArtist() {

  const artist =
    document.getElementById(
      "artistNameInput"
    ).value;

  const song =
    document.getElementById(
      "artistSongInput"
    ).value;

  if(!artist || !song){
    return;
  }

  const card =
    document.createElement("div");

  card.className = "artist-card";

  card.innerHTML =
    "<h3>" + artist + "</h3>" +
    "<p>🎵 Latest Song: " + song + "</p>";

  document
    .getElementById("artistList")
    .appendChild(card);

  let artists =
JSON.parse(
localStorage.getItem("artists")
) || [];

artists.push({
  name: artist,
  song: song
});

localStorage.setItem(
  "artists",
  JSON.stringify(artists)
);
  
  document
    .getElementById("artistNameInput")
    .value = "";

  document
    .getElementById("artistSongInput")
    .value = "";
}
// For Firebase JS SDK v7.20.0 and later, measurementId is optional
const firebaseConfig = {
  apiKey: "AIzaSyDW-K6YPOX4ekTPyZmU-br71qTZPaVJzZQ",
  authDomain: "ethio-ai-92723.firebaseapp.com",
  projectId: "ethio-ai-92723",
  storageBucket: "ethio-ai-92723.firebasestorage.app",
  messagingSenderId: "341002895954",
  appId: "1:341002895954:web:95753f54f20101eefed58b",
  measurementId: "G-ZLYXQFFVWB"
};
firebase.initializeApp(firebaseConfig);

const db = firebase.firestore();
const auth = firebase.auth();

console.log("Firebase Connected!");
function signupUser() {
  const email = document.getElementById("signupEmail").value;
  const password = document.getElementById("signupPassword").value;

  auth.createUserWithEmailAndPassword(email, password)
    .then(() => {
      alert("Account Created!");
    })
    .catch(error => {
      alert(error.message);
    });
}

function loginUser() {
  const email = document.getElementById("loginEmail").value;
  const password = document.getElementById("loginPassword").value;

  auth.signInWithEmailAndPassword(email, password)
    .then(() => {
      document.getElementById("loginMessage").innerHTML = "Login Successful!";
    })
    .catch(error => {
      document.getElementById("loginMessage").innerHTML = error.message;
    });
}

function logoutUser() {
  auth.signOut();
}
auth.onAuthStateChanged((user) => {
  if (user) {
    document.getElementById("userEmail").textContent =
      user.email;
  }
});
window.onload = function(){

  let artists =
  JSON.parse(
    localStorage.getItem("artists")
  ) || [];

  artists.forEach(function(item){

    const card =
      document.createElement("div");

    card.className =
      "artist-card";

    card.innerHTML =
      "<h3>" + item.name + "</h3>" +
      "<p>🎵 Latest Song: " +
      item.song +
      "</p>";

    document
      .getElementById("artistList")
      .appendChild(card);

  });

};
  
 function playSong(songUrl, songName) {
  const player = document.getElementById("audioPlayer");

  console.log(songUrl);

  player.src = songUrl;

  document.getElementById("currentSong").textContent = songName;

  player.play().catch(error => {
    console.log(error);
  });
}


// PASTE NEW CODE HERE

function addFavoriteSong() {
  const song =
    document.getElementById("favoriteSong").value;

  if(song === "") return;

  const li =
    document.createElement("li");

  li.textContent = song;

  document
    .getElementById("playlist")
    .appendChild(li);

  document
    .getElementById("favoriteSong")
    .value = "";
}
function addComment() {

  const input =
    document.getElementById("commentInput");

  const comment =
    input.value;

  if(comment === "") return;

  const li =
    document.createElement("li");

  li.textContent = comment;

  document
    .getElementById("commentList")
    .appendChild(li);

  
 input.value = "";

}

function likeSong() {
  let likes = document.getElementById("likeCount");
  let count = parseInt(likes.textContent);

  count++;
  likes.textContent = count;

  localStorage.setItem("songLikes", count);
}
window.onload = function() {
  let savedLikes = localStorage.getItem("songLikes");

  if (savedLikes) {
    document.getElementById("likeCount").textContent = savedLikes;
  }
};
  
  
  
let views = localStorage.getItem("pageViews");

if (!views) {
  views = 0;
}

views++;
localStorage.setItem("pageViews", views);

document.getElementById("viewCount").textContent = views;