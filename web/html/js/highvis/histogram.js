// Generated by CoffeeScript 1.3.3

/*
 * Copyright (c) 2011, iSENSE Project. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this
 * list of conditions and the following disclaimer. Redistributions in binary
 * form must reproduce the above copyright notice, this list of conditions and
 * the following disclaimer in the documentation and/or other materials
 * provided with the distribution. Neither the name of the University of
 * Massachusetts Lowell nor the names of its contributors may be used to
 * endorse or promote products derived from this software without specific
 * prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
 * DAMAGE.
 *
*/


(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  window.Histogram = (function(_super) {

    __extends(Histogram, _super);

    function Histogram(canvas) {
      this.canvas = canvas;
      this.displayField = data.normalFields[0];
      this.binSize = this.defaultBinSize();
    }

    Histogram.prototype.buildOptions = function() {
      var self,
        _this = this;
      Histogram.__super__.buildOptions.call(this);
      self = this;
      this.chartOptions;
      return $.extend(true, this.chartOptions, {
        chart: {
          type: "column"
        },
        title: {
          text: "Histogram"
        },
        legend: {
          symbolWidth: 0
        },
        plotOptions: {
          column: {
            stacking: 'normal',
            groupPadding: 0,
            pointPadding: 0
          },
          series: {
            events: {
              legendItemClick: (function() {
                return function(event) {
                  self.displayField = this.options.legendIndex;
                  self.binSize = self.defaultBinSize();
                  ($("#binSizeInput")).attr('value', self.binSize);
                  return self.delayedUpdate();
                };
              })()
            }
          }
        }
      });
    };

    /*
        Returns a rough default 'human-like' bin size selection
    */


    Histogram.prototype.defaultBinSize = function() {
      var curSize, done, groupIndex, highBound, localMax, localMin, lowBound, max, min, range, _i, _len, _ref;
      lowBound = 10;
      highBound = 35;
      min = Number.MAX_VALUE;
      max = Number.MIN_VALUE;
      _ref = globals.groupSelection;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        groupIndex = _ref[_i];
        localMin = data.getMin(this.displayField, groupIndex);
        if (localMin !== null) {
          min = Math.min(min, localMin);
        }
        localMax = data.getMax(this.displayField, groupIndex);
        if (localMax !== null) {
          max = Math.max(max, localMax);
        }
      }
      range = max - min;
      if (max < min) {
        return 1;
      }
      curSize = 1;
      done = function(s) {
        var _ref1;
        return (highBound > (_ref1 = range / s) && _ref1 > lowBound);
      };
      while (!(done(curSize))) {
        if ((range / curSize) < lowBound) {
          if (done(curSize / 2)) {
            return curSize / 2;
          }
          if (done(curSize / 5)) {
            return curSize / 5;
          }
          curSize /= 10;
        } else if ((range / curSize) > highBound) {
          if (done(curSize * 2)) {
            return curSize * 2;
          }
          if (done(curSize * 5)) {
            return curSize * 5;
          }
          curSize *= 10;
        }
      }
      return curSize;
    };

    Histogram.prototype.update = function() {
      var bin, binArr, fakeDat, finalData, globalmax, globalmin, groupIndex, i, max, min, number, occurences, options, selecteddata, tempData, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
      Histogram.__super__.update.call(this);
      while (this.chart.series.length > data.normalFields.length) {
        this.chart.series[this.chart.series.length - 1].remove(false);
      }
      /* ---
      */

      globalmin = Number.MAX_VALUE;
      globalmax = Number.MIN_VALUE;
      _ref = globals.groupSelection;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        groupIndex = _ref[_i];
        min = data.getMin(this.displayField, groupIndex);
        min = Math.round(min / this.binSize) * this.binSize;
        globalmin = Math.min(globalmin, min);
        max = data.getMax(this.displayField, groupIndex);
        max = Math.round(max / this.binSize) * this.binSize;
        globalmax = Math.max(globalmax, max);
      }
      fakeDat = (function() {
        var _j, _ref1, _results;
        _results = [];
        for (i = _j = globalmin, _ref1 = this.binSize; globalmin <= globalmax ? _j < globalmax : _j > globalmax; i = _j += _ref1) {
          _results.push([i, 0]);
        }
        return _results;
      }).call(this);
      options = {
        showInLegend: false,
        data: fakeDat
      };
      this.chart.addSeries(options, false);
      /*
      */

      _ref1 = globals.groupSelection;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        groupIndex = _ref1[_j];
        selecteddata = data.selector(this.displayField, groupIndex);
        binArr = (function() {
          var _k, _len2, _results;
          _results = [];
          for (_k = 0, _len2 = selecteddata.length; _k < _len2; _k++) {
            i = selecteddata[_k];
            _results.push(Math.round(i / this.binSize) * this.binSize);
          }
          return _results;
        }).call(this);
        tempData = {};
        for (_k = 0, _len2 = binArr.length; _k < _len2; _k++) {
          bin = binArr[_k];
          if ((_ref2 = tempData[bin]) == null) {
            tempData[bin] = 0;
          }
          tempData[bin]++;
        }
        finalData = (function() {
          var _results;
          _results = [];
          for (number in tempData) {
            occurences = tempData[number];
            _results.push([Number(number), occurences]);
          }
          return _results;
        })();
        /* ---
        */

        options = {
          showInLegend: false,
          color: globals.colors[groupIndex % globals.colors.length],
          name: data.groups[groupIndex],
          data: finalData
        };
        this.chart.addSeries(options, false);
      }
      this.chart.xAxis[0].setExtremes(globalmin - (this.binSize / 2), globalmax + (this.binSize / 2), false);
      return this.chart.redraw();
    };

    Histogram.prototype.buildLegendSeries = function() {
      var count, dummy, field, fieldIndex, _i, _len, _ref, _results;
      count = -1;
      _ref = data.fields;
      _results = [];
      for (fieldIndex = _i = 0, _len = _ref.length; _i < _len; fieldIndex = ++_i) {
        field = _ref[fieldIndex];
        if (!(__indexOf.call(data.normalFields, fieldIndex) >= 0)) {
          continue;
        }
        count += 1;
        _results.push(dummy = {
          data: [],
          color: '#000',
          visible: this.displayField === fieldIndex,
          name: field.fieldName,
          type: 'area',
          xAxis: 1,
          legendIndex: fieldIndex
        });
      }
      return _results;
    };

    Histogram.prototype.drawToolControls = function() {
      var controls, _ref,
        _this = this;
      controls = "";
      controls += '<div id="toolControl" class="vis_controls">';
      controls += "<h3 class='clean_shrink'><a href='#'>Tools:</a></h3>";
      controls += "<div class='inner_control_div'>";
      controls += "Bin Size: <input id='binSizeInput' type='text' value='" + this.binSize + "' size='" + 4 + "'></input>";
      controls += '</div></div></div>';
      ($('#controldiv')).append(controls);
      if ((_ref = globals.toolsOpen) == null) {
        globals.toolsOpen = 0;
      }
      ($('#toolControl')).accordion({
        collapsible: true,
        active: globals.toolsOpen
      });
      ($('#toolControl > h3')).click(function() {
        return globals.toolsOpen = (globals.toolsOpen + 1) % 2;
      });
      return ($("#binSizeInput")).keydown(function() {
        if (event.keyCode === 13) {
          _this.binSize = Number(($('#binSizeInput')).val());
          return _this.update();
        }
      });
    };

    Histogram.prototype.drawControls = function() {
      Histogram.__super__.drawControls.call(this);
      this.drawGroupControls();
      return this.drawToolControls();
    };

    return Histogram;

  })(BaseHighVis);

  if (__indexOf.call(data.relVis, "Histogram") >= 0) {
    globals.histogram = new Histogram('histogram_canvas');
  } else {
    globals.histogram = new DisabledVis('histogram_canvas');
  }

}).call(this);
