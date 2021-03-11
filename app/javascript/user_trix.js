window.addEventListener('DOMContentLoaded', function() {
  var image = document.getElementById("user_image");
  image.addEventListener("change", function() {
    console.log("hi");
    var size_in_megabytes = this.files[0].size/1024/1024;
    if (size_in_megabytes > 5) {
      alert("画像ファイルは5MBよりも小さいものにしてください");
      image.value = "";
    }
  });
}, false);

