import Trix from "trix"

document.addEventListener("turbolinks:load", () => {
  if (document.getElementById("article_content")) {    
    const trix_button = document.getElementsByClassName("trix-button--icon-link")
    const button = trix_button.[trix_button.length - 1]
    button.addEventListener("click", e => {
      e.preventDefault();
      insertLinkcard();
    });
  };
});

function insertLinkcard() {
  const url = prompt("埋め込みたいURLを貼ってください");
  if (url) {
    fetchEmbbedLink(url);
  }
}

function fetchEmbbedLink(url){
  let hashData = {
    oembed: { body: url }
  };
  let data = JSON.stringify(hashData);
  let token = document.getElementsByName("csrf-token")[0].content;
  let xmlHR = new XMLHttpRequest();  
  xmlHR.open("POST", '/oembed', true);  
  xmlHR.responseType = "json";  
  xmlHR.setRequestHeader("Content-Type", "application/json");  
  xmlHR.setRequestHeader("X-CSRF-Token", token);  
  xmlHR.send(data);  
  xmlHR.onreadystatechange = function() {
    if (xmlHR.readyState === 4) {  
      if (xmlHR.status === 200) {  
        const trixElement = document.getElementById("article_content")
        const editor = trixElement.editor

        const attachment = new Trix.Attachment({
          content: xmlHR.response.html,
          sgid: xmlHR.response.sgid
        });
        editor.insertAttachment(attachment)
      } else {  
        alert("error");
      };
    };
  };
};
