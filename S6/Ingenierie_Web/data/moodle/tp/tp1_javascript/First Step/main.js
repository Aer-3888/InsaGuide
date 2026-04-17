/*
    First Steps : JavaScript
*/

// Utilities and basic variables

const customName = document.getElementById('customname');
const randomize = document.querySelector('.randomize');
const story = document.querySelector('.story');

function randomValueFromArray(array) {
    const random = Math.floor(Math.random() * array.length);
    return array[random];
}

// Static text content

let storyText = "It was 94 fahrenheit outside, so :insertx: went for a walk. When they got to :inserty:, they stared in horror for a few moments, then :insertz:. Bob saw the whole thing, but was not surprised — :insertx: weighs 300 pounds, and it was a hot day."

let insertX = ["Willy the Goblin", "Big Daddy", "Father Christmas"]
let insertY = ["the soup kitchen", "Disneyland", "the White House"]
let insertZ = ["spontaneously combusted", "melted into a puddle on the sidewalk", "turned into a slug and crawled away"]

// Randomizer and event listener

randomize.addEventListener('click', result);

function result() {
    let newStory = storyText;
    let xItem  = randomValueFromArray(insertX);
    let yItem  = randomValueFromArray(insertY);
    let zItem  = randomValueFromArray(insertZ);
    // Replace the placeholders
    for (let i = 0; i < 2; i++)
        newStory = newStory.replace(":insertx:", xItem);
    newStory = newStory.replace(":inserty:", yItem);
    newStory = newStory.replace(":insertz:", zItem);

    if(customName.value !== '') {
        let name = customName.value;
        newStory = newStory.replace("Bob", name);
    }

    if(document.getElementById("uk").checked) {
        let weight = Math.round(300*0.0714286) + " stone";
        let temperature =  Math.round((94 - 32) * 5/9) + " centigrade";
        newStory.replace("94 farenheit", temperature);
        newStory.replace("300 pounds", weight);
    }

    story.textContent = newStory;
    story.style.visibility = 'visible';
}
