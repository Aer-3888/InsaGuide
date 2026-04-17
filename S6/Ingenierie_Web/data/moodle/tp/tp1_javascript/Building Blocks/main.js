const displayedImage = document.querySelector('.displayed-img');
const thumbBar = document.querySelector('.thumb-bar');

const btn = document.querySelector('button');
const overlay = document.querySelector('.overlay');

/* Looping through images */

const maximage = 5;

for (let i = 1; i <= maximage; i++) {
    const imgname = "images/pic" + i + ".jpg";
    const newImage = document.createElement('img');
    newImage.setAttribute('src', imgname);
    thumbBar.appendChild(newImage);
}

thumbBar.onclick = function(event) {
    displayedImage.setAttribute("src", event.target.src);
}

/* Wiring up the Darken/Lighten button */
btn.onclick = function(event) {
    if (btn.getAttribute("class") == "dark") {
        btn.setAttribute("class", "light");
        btn.textContent = "Lighten";
        overlay.style.backgroundColor = "rgba(0,0,0,0.5)";
    } else {
        btn.setAttribute("class", "dark");
        btn.textContent = "Darken";
        overlay.style.backgroundColor = "rgba(0,0,0,0)";
    }
}