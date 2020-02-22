//


let index = 0;

function prepare() {
  let size = document.querySelectorAll(".slide").length;
  document.addEventListener("keydown", (event) => {
    if (event.key === "ArrowLeft") {
      if (index > 0) {
        index --;
      }
      scroll();
    } else if (event.key === "ArrowRight") {
      if (index < size - 1) {
        index ++;
      }
      scroll();
    }
  });
}

function scroll() {
  document.querySelectorAll(".slide")[index].scrollIntoView();
  console.log("Page: " + index);
}

window.onload = prepare;