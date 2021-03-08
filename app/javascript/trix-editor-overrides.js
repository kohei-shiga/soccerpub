window.addEventListener("trix-file-accept", function(e) {
  const acceptedTypes = ['image/jpeg', 'image/png', 'image/jpg', 'image/gif'];
  if (!acceptedTypes.includes(e.file.type)) {
    e.preventDefault();
    alert("jpeg, png, gif, jpgファイルのみ対応しています。");
  }
});