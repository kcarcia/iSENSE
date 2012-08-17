###
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
###

class window.Motion extends BaseVis
    constructor: (@canvas) -> 

    start: ->
        #Make table visible? (or somthing)
        ($ '#' + @canvas).show()
        
        dt = new google.visualization.DataTable();
        
        for field,fieldIndex in data.fields
            switch (Number field.typeID)
                when data.types.TEXT then dt.addColumn('string', field.fieldName) 
                when data.types.TIME then dt.addColumn('date', field.fieldName)
                else dt.addColumn('number', field.fieldName)
        
        rows = for dataPoint in data.dataPoints
            line = for dat, fieldIndex in dataPoint 
                if((Number data.fields[fieldIndex].typeID) is data.types.TIME)
                    new Date(dat)
                else 
                    dat
            line
        
        dt.addRow(row) for row in rows
                   
        chart = new google.visualization.MotionChart(document.getElementById('motion_canvas'));
        chart.draw(dt, {width: 850, height:490});
        super()

    #Gets called when the controls are clicked and at start
    update: ->
        super()

    end: ->
        ($ '#' + @canvas).hide()
        
    drawControls: ->

    drawChart: ->

        
globals.motion = new Motion "motion_canvas"