// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var simplemde = new SimpleMDE({ 
  element: document.getElementById("editor"),
  toolbar: [
    "bold", "italic", "heading", "strikethrough", "|",
    "quote", "unordered-list", "ordered-list", "|",
    "link", "image", "table", "horizontal-rule", "|",
    "preview", "side-by-side", "fullscreen", "|", "guide"
  ],
  insertTexts: {
        horizontalRule: ["", "\n\n-----\n\n"],
        image: ["![](http://", ")"],
        link: ["[", "](http://)"],
        table: ["", "\n\n| Column 1 | Column 2 | Column 3 |\n| -------- | -------- | -------- |\n| Text     | Text      | Text     |\n\n"],
    }
});
