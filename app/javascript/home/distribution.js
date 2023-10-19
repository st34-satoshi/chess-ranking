import "application"
import "chart.js"

function createRatingDistributionGraph(){
    let ratings = $('#ratingDistributionChart').data('ratings');
    console.log('ratings')
    console.log(ratings)
    const labels = [1,2,3,4,5,6,7,8,9,'a','s','d'];
    const data = {
      labels: labels,
      datasets: [{
        label: 'My First Dataset',
        data: [65, 59, 80, 81, 56, 55, 40],
        fill: false,
        borderColor: 'rgb(75, 192, 192)',
        tension: 0.1
      }]
    };

    const config = {
      type: 'line',
      data,
      options: {}
    };

    const ratingDistributionChart = new Chart(
      document.getElementById('ratingDistributionChart'),
      config
    );
}

$(function() {
    createRatingDistributionGraph()
});