var _MainPoints = [
    {
      x: 0,
      y: 40
    }, {
      x: 38,
      y: 12.4
    }, {
      x: 23.5,
      y: -32.4
    }, {
      x: -23.5,
      y: -32.4
    }, {
      x: -38,
      y: 12.4
    }, {
      x: 0,
      y: 40
    }
  ];

var _SegmentPos1 = [
    {
      points: [ {p1: 0, p2: 0, p3: 1}, {p1: 0, p2: 0.23, p3: 0.77}, {p1: 0.64, p2: 0.23, p3: 0.13}, {p1: 0.87, p2: 0, p3: 0.13} ],
      fill: 'rgb(190,232,255)',
      label: { text: 'D1', cx: 0.08, cy: -0.04, withLine: false, endX: null, endY: null }
    },
    {
      points: [ {p1: 0, p2: 0.23, p3: 0.77}, {p1: 0, p2: 0.71, p3: 0.29}, {p1: 0.31, p2: 0.4, p3: 0.29}, {p1: 0.47, p2: 0.4, p3: 0.13}, {p1: 0.64, p2: 0.23, p3: 0.13} ],
      fill: 'rgb(35,107,254)',
      label: { text: 'D2', cx: -0.04, cy: 0.52, withLine: false, endX: null, endY: null }
    },
    {
      points: [ {p1: 0, p2: 0.71, p3: 0.29}, {p1: 0, p2: 0.85, p3: 0.15}, {p1: 0.35, p2: 0.5, p3: 0.15}, {p1: 0.46, p2: 0.5, p3: 0.04}, {p1: 0.96, p2: 0, p3: 0.04}, {p1: 0.87, p2: 0, p3: 0.13}, {p1: 0.47, p2: 0.4, p3: 0.13}, {p1: 0.31, p2: 0.4, p3: 0.29} ],
      fill: 'rgb(0,132,189)',
      label: { text: 'DT', cx: -0.04, cy: 0.78, withLine: false, endX: null, endY: null }
    },
    {
      points: [ {p1: 0.76, p2: 0.2, p3: 0.04}, {p1: 0.8, p2: 0.2, p3: 0}, {p1: 0.8, p2: 0.2, p3: 0}, {p1: 0.98, p2: 0.02, p3: 0}, {p1: 0.98, p2: 0, p3: 0.02}, {p1: 0.96, p2: 0, p3: 0.04} ],
      fill: 'rgb(97,200,241)',
      label: { text: 'T1', cx: 0.92, cy: 0.12, withLine: false, endX: null, endY: null }
    },
    {
      points: [ {p1: 0.46, p2: 0.5, p3: 0.04}, {p1: 0.5, p2: 0.5, p3: 0}, {p1: 0.8, p2: 0.2, p3: 0}, {p1: 0.76, p2: 0.2, p3: 0.04} ],
      fill: 'rgb(145,148,255)',
      label: { text: 'T2', cx: 0.7, cy: 0.34, withLine: false, endX: null, endY: null }
    },
    {
      points: [ {p1: 0, p2: 0.85, p3: 0.15}, {p1: 0, p2: 1, p3: 0}, {p1: 0.5, p2: 0.5, p3: 0}, {p1: 0.35, p2: 0.5, p3: 0.15} ],
      fill: 'rgb(218,220,255)',
      label: { text: 'T3', cx: 0.3, cy: 0.75, withLine: false, endX: null, endY: null }
    },
    {
      points: [ {p1: 0.98, p2: 0.02, p3: 0}, {p1: 1, p2: 0, p3: 0}, {p1: 0.98, p2: 0, p3: 0.02} ],
      fill: 'rgb(87,56,191)',
      label: { text: 'PD', cx: 1.02, cy: -0.01, withLine: false, endX: null, endY: null }
    },
    
];
 
var legendTexts = ['PD = Partial Discharge',
  'T1 = Thermal fault < 300 celcius',
  'T2 = Thermal fault 300 < T < 700 celcius',
  'T3 = Thermal fault < 300 celcius',
  'D1 = Thermal fault T > 700 celcius',
  'D2 = Discharge of High Energy',
  'DT = Electrical and Thermal'
];
var vector0 = {
  x: 0,
  y: 0
};
var vector1 = {
  x: 1,
  y: 0
};
var vector2 = {
  x: 0,
  y: 1
};
var _TriangleTexts = {
  normal : [
          { start: vector0, end: vector1 , text: "%CH4", offset: 60, angle: Math.PI},
          { start: vector1, end: vector2 , text: "%C2H4", offset: 60, angle: 0},
          { start: vector2, end: vector0 , text: "%C2H2", offset: 40, angle: Math.PI/2}
        ] 
}
//xxx@gmail.com
//https://codepen.io/carlosmola6la/pen/jOadmmP

let _RegistryData = [ // hid : H2, met : CH4, eti : C2H4 , eta : C2H6, ace : C2H2
 
 
    { 
      "id":1,
      "triangle_type":"triangle_MEA",     
      "num_met":55,//<%= @chromatographical.num_met %>,
      "num_eti":22,//<%= @chromatographical.num_eti %>,
      "num_ace":11,//<%= @chromatographical.num_ace %>,
      "tr1_met_percent":11,//<%= @chromatographical.tr1_met_percent %>,
      "tr1_eti_percent":12,//<%= @chromatographical.tr1_eti_percent %>,
      "tr1_ace_percent":13//<%= @chromatographical.tr1_ace_percent %>            
  } 
];
// const xhr = new XMLHttpRequest();
// const url = 'https://tr.mydentistcorin.com/cromas/23.json';

// xhr.open('GET', url, true);
// xhr.send();
let _RegistryPosition1 = [] ;
