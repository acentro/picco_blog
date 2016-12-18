// Select each textarea with the class picco_blog_editor and add SimpleMDE editor

$('textarea.picco_blog_editor').each(function() {
    var simplemde = new SimpleMDE({
        element: this,
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
        },
        status: false
    });
    simplemde.render(); 
});
