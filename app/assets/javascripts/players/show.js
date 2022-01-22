function createGraph(){
    let records = $('#ratingChart').data('record');
    let dates = $('#ratingChart').data('date');

    const data = {
      labels: dates,
      datasets: [{
        label: 'Rating',
        backgroundColor: 'rgb(255, 99, 132)',
        borderColor: 'rgb(255, 99, 132)',
        data: [records[dates[0]]['rating']],
      }]
    };

    const config = {
      type: 'line',
      data,
      options: {}
    };

    var myChart = new Chart(
      document.getElementById('ratingChart'),
      config
    );
}

$(function() {
    createGraph();
});