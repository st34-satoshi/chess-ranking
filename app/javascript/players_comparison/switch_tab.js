import "bootstrap";

document.addEventListener('DOMContentLoaded', () => {
  const inputTab = document.getElementById('input-tab');
  const urlTab = document.getElementById('url-tab');
  
  inputTab.addEventListener('click', () => {
    const tab = new bootstrap.Tab(inputTab);
    tab.show();
  });
  
  urlTab.addEventListener('click', () => {
    const tab = new bootstrap.Tab(urlTab);
    tab.show();
  });
});