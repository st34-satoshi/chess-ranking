import "chart.js"

function createGraph() {
  let records = $('#playersComparisonChart').data('players-records');
  let dates = $('#playersComparisonChart').data('dates');
  console.log(records);
  console.log(dates);

  let graphData = [];
  const skipped = (ctx, value) => ctx.p0.skip || ctx.p1.skip ? value : undefined;
  for (let i = 0; i < records.length; i++) {
    const ratings = [];
    for (let j = 0; j < dates.length; j++) {
      if (records[i]['ratings'][dates[j]]) {
        ratings.push(records[i]['ratings'][dates[j]]);
      }else{
        ratings.push(null);
      }
    }
    let data = {
      label: records[i]['name'],
      data: ratings,
      spanGaps: true,
      fill: false,
      borderColor: `hsl(${i * 360 / records.length}, 70%, 50%)`,  // 色相を均等に分配
      backgroundColor: `hsl(${i * 360 / records.length}, 70%, 50%)`,  // 同じ色を背景にも設定
      segment: {
        borderColor: ctx => skipped(ctx, 'rgb(0,0,0,0.2)'),
        borderDash: ctx => skipped(ctx, [6, 6]),
      },
    }
    graphData.push(data);
  }

  const data = {
    labels: dates,
    datasets: graphData
  };

  const config = {
    type: 'line',
    data,
    options: {
        scales: {
          y: {
            reverse: true,
            axis: 'r'
          }
        }
      }
  };

  var playersComparisonChart = new Chart(
    document.getElementById('playersComparisonChart'),
    config
  );
}

document.addEventListener('DOMContentLoaded', () => {
  createGraph();
});