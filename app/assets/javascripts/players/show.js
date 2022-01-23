function createGraph(){
    let records = $('#ratingChart').data('record');
    let dates = $('#ratingChart').data('date');
    let ratings = [];
    dates.forEach(function(date){
      let rating = 0;
      if (date in records){
        rating = records[date]['rating'];
      }
      ratings.push(rating);
    });

    const data = {
      labels: dates,
      datasets: [{
        label: 'Rating',
        backgroundColor: 'rgb(255, 99, 132)',
        borderColor: 'rgb(255, 99, 132)',
        data: ratings,
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