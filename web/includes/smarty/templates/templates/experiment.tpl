{*
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
 *}

<script> 
    var default_vis = '{$meta.default_vis}';
{literal}
    $(document).ready(function(){
                $( ".exp_tools a").button().width('100px').css({margin:'0px 0px 6px 0px',fontSize:'1em',fontFamily:'Trebuchet MS, sans-serif',fontWeight:'bold'});
                $("#defult_vis_selector").val(default_vis);
    });
{/literal}    
</script>

<div id="main">
	{ include file="parts/errors.tpl" }
	<div id="details" style="min-height:60px; margin:0px 0px 0px 0px;">
		<div>
			<table width="100%" class="profile">
				<tr>
				    { if not $activity }
					    <td class="heading" valign="top">Procedure:</td>
					{ else }
					    <td class="heading" valign="top">Instructions:</td>
					{ /if }
					<td>{ $meta.description }</td>
				</tr>
				<tr>
					<td class="heading" valign="top">Fields:</td>
					<td>
						{ section name=foo loop=$fields }
							{ $fields[foo].field_name } ({ $fields[foo].unit_abbreviation }){ if $smarty.section.foo.total-1 != $smarty.section.foo.index }, { /if }
						{ /section }
					</td>
				</tr>
				<tr>
					<td class="heading" valign="top">Tags:</td>
					<td>
						{ if $tags }
							{ section name=foo loop=$tags }
								<a href="browse.php?action=search&amp;query={ $tag.tag }">{ $tags[foo].tag }</a>{ if $smarty.section.foo.total-1 != $smarty.section.foo.index }, { /if }
							{ /section }
						{ /if }
					</td>
				</tr>	
				<tr>
					<td class="heading" valign="top">Creator:</td>
					<td><a href="profile.php?id={ $meta.owner_id }">{ $meta.firstname } { $meta.lastname }</a></td>
				</tr>
				<tr>
					<td class="heading" valign="top">Created:</td>
					<td>{ $meta.timecreated }</td>
				</tr>
				<tr>
					<td class="heading" valign="top">Last Updated:</td>
					<td>{ $meta.timemodified }</td>
				</tr>
				{ if $user.administrator == 1 }
					<tr>
						<td class="heading" valign="top">Feature:</td>
						<td>
							<input type="checkbox" id="feature_experiment" name="feature_experiment" value="{$meta.experiment_id}" {if $meta.featured == 1}checked{/if}/>
							<span id="loading_msg" style="display:none;">Loading...</span>
						</td>
					</tr>
                    <tr>
                        <td class="heading" valign="top">Recommend:</td>
                        <td>
                            <input type="checkbox" id="recommend_experiment" name="recommend_experiment" value="{$meta.experiment_id}" {if $meta.recommended == 1}checked{/if}/>
                            <span id="recommended_loading_msg" style="display:none;">Loading...</span>
                        </td>
                    </tr>
					<tr>
						<td class="heading" valign="top">Hidden:</td>
						<td>
							<input type="checkbox" id="hide_experiment" name="hide_experiment" value="{$meta.experiment_id}" {if $meta.hidden == 1}checked{/if}/>
							<span id="hidden_loading_msg" style="display:none;">Loading...</span>
						</td>
					</tr>
				{ /if }
				{ if $user.user_id == $meta.owner_id or $user.administrator == 1 }
                                    <tr>
                                        <td class="heading" valign="top">Closed:</td>
                                        <td>
                                            <input type="checkbox" id="close_experiment" name="close_experiment" value="{$meta.experiment_id}" {if $meta.closed == 1}checked{/if}/>
                                            <span id="close_loading_message" style="display:none;">Loading...</span>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td class="heading" valign="top">Default Vis:</td>
                                        <td>
                                            <select id="defult_vis_selector">
                                                <option value="Map">Map</option>
                                                <option value="Timeline">Timeline</option>
                                                <option value="Scatter">Scatter</option>
                                                <option value="Bar">Bar</option>
                                                <option value="Histogram">Histogram</option>
                                                <option value="Motion">Motion</option>
                                                <option value="Pictures" >Pictures</option>
                                            </select>
                                        </td>
                                    </tr>
                                { /if }
			</table>
		</div>
	</div>
	<div id="sessions" style="min-height:60px; margin:20px 0px 0px 0px;">
	    { if $activity and !$user.guest }
	        <div style="margin:6px 0px;">
    			<div class="featured_head">
    			    <div>Activity Tools</div>
    			</div>
        	    <div class="featured_body" style="padding:6px 0px 6px 6px;">
        	        <div><input type="submit" style="width:73px;" value="{if not $activity}Visualize{else}Complete{/if}" onclick="loadVis({$meta.experiment_id}, {if $activity}true{else}false{/if});"/> - {if $activity}View data for this experiment and solve for the prompt.{else}Select sessions below to visualize data{/if}</div>
        	    </div>
        	</div>
	    { /if }
	    
	    { if not $activity }
	        <div style="margin:6px 0px;">
			    <div class="featured_head">
			        <div>Experiment Tools</div>
			    </div>
    	        <div class="featured_body" style="padding:6px 0px 6px 6px;">
    	            { if !$user.guest }

			{ if $meta.experiment_id == 350 }
    	                	<div class="exp_tools"><a href="./tsor.php">Contribute</a> - Contribute data to this experiment.</div>
			{ else }
                            <div class="exp_tools" {if $meta.closed == 1 }hidden="hidden" {/if} > <a href="./upload.php?id={$meta.experiment_id}">Contribute</a> - Contribute data to this experiment.</div>
		        { /if }

    	                <div class="exp_tools"><a href="#" onclick="loadExport({$meta.experiment_id});">Export</a> - Download data from selected sessions.</div>
    	                { if $user.user_id == $meta.owner_id or $user.administrator == 1 }
    	                    <div class="exp_tools"><a href="experiment-edit.php?id={$meta.experiment_id}">Edit</a> - Edit this experiment.</div>
    	                    <div class="exp_tools"><a href="pickexpimage.php?id={$meta.experiment_id}">Image</a> - Set the picture that will show should this experiment be featured.</div>
                        { /if }
    	            { /if }
            	    <div class="exp_tools"><a href="#" onclick="loadVis2({$meta.experiment_id});">Visualize</a> - Use our visualizations beta to examine your data. </div>
    	        </div>
    	    </div>
	    { /if }
	    
		<div style="margin:6px 0px;">
			<div class="popular_head">
				<div style="float:right;"><a href="javascript:void(0);" onclick="checkAll('#session_list');">Check All</a> | <a href="javascript:void(0);" onclick="uncheckAll('#session_list');">Uncheck All</a></div>
				<div>Experiment Data</div>
			</div>
			<div class="popular_body">
				<div id="session_list" width="100%" cellpadding="0" cellspacing="0">
                    { if $sessions }
                        { foreach from=$sessions item=session key=i }
                                <div class="session_cell">
                                    <div class="session_select">
                                        <input type="checkbox" name="sessions" value="{$session.session_id}" {if $i == 0}checked{/if} />
                                    </div>
                                    
                                    <div class="owner_img">
                                        <img src="{$session.owner_avatar}&h=32&w=32" width="32px" height="32px" />
                                    </div>
                                    
                                    <div class="owner_name">
                                        <a href="profile.php?id={ $session.owner_id }">{ $session.firstname } { $session.lastname }</a>
                                    </div>
                                    
                                    <div class="session_name">
                                        <a href="highvis.php?sessions={ $session.session_id }">{ $session.name|truncate:27 }</a>
                                    </div>
                                    
                                    <div class="pictures_maybe">
                                        { counter start=0 skip=1 assign='imginc' }
                                        { foreach from=$expimages item=expimg key=j }
                                            { if $expimg.session_id == $session.session_id && $imginc < 7 }
                                                { counter }
                                                <a class="nounderline" href="{ $expimg.provider_url }">
                                                    <img src="{ $expimg.provider_url }" width="30px" height="30px"/>
                                                </a>
                                            { /if }
                                        { /foreach }
                                    </div>
                                    
                                    {if $user.administrator == 1 or $meta.owner_id == $user.user_id or $session.owner_id == $user.user_id}
                                        <div id="experiment_control_panel">
                                            <div class="add_img">
                                                {if $user.administrator == 1 or $meta.owner_id == $user.user_id or $session.owner_id == $user.user_id}
                                                    <a href="session-upload-pictures.php?sid={ $session.session_id }&id={ $id }">Add Image</a>
                                                { /if }
                                            </div>
                                            
                                            <div class="edit_session">
                                                { if $user.administrator == 1 or $meta.owner_id == $user.user_id or $session.owner_id == $user.user_id}
                                                    <a href="javascript:void(0);" onclick="window.location.href='session-edit.php?id={$session.session_id}';">Edit Session</a>
                                                { /if }
                                            </div>
                                            
                                            <div class="edit_data">
                                                {if $user.administrator == 1 or $session.owner_id == $user.user_id}
                                                    <a href-"javasript:void(0)" onclick="window.location.href='/edit.php?exp={$session.experiment_id}&ses={$session.session_id}';">Edit Data</a>
                                                { /if }
                                            </div>
                                        </div>
                                    {/if}
                                </div>
                        { /foreach }
					{ /if }
				</div>
			</div>
		</div>
	</div>
</div>

<div id="sidebar">
	<div class="module">
		<h1>QR Code</h1>

		<div id="qrcode" style="text-align: center;"><img src="{$qrcode}" /><div id="qrcode" style="margin:4px 0px 0px 0px;  overflow:hidden;"></div></div>
	</div>
	
	<div class="module">
		<h1>Community Rating</h1>
		<div id="community_rating" style="height:16px; padding:4px 0px; text-align:center;">
			{ if $user.guest }
				<span class="star-rating-control">
					{ section name=foo start=1 loop=6 step=1 }
						<div id="star{$smarty.section.foo.index}" class="star-rating rater-0 star star-rating-applied {if $smarty.section.foo.index lte $rating }star-rating-hover{/if} unclickable">
							<a title="on" disabled="disabled">on</a>
						</div>
					{ /section }
				</span>
			{ else }
				{ section name=foo start=1 loop=6 step=1 }
					<input id="star{$smarty.section.foo.index}" name="star" type="radio" class="star"/>
				{ /section}
			{ /if }
		</div>
		<div id="rating_prompt">
			<input id="rating" name="rating" value="{ $rating }" type="hidden" />
			{ if $user.guest }
				<a href="login.php?ref={$smarty.server.SCRIPT_NAME}?{$smarty.server.QUERY_STRING}">Login</a> or <a href="register.php">Join</a> to rate.
			{ else }
				Click a star to add your rating.
			{ /if }
		</div>
	</div>
	
	{ if not $activity }
	    <div class="module">
    		<h1>Visualizations</h1>
    		{ if $vises }
    			<div id="vises">
    				<table width="100%">
    					{ foreach from=$vises item=vis }
    						<tr>
    							<td><a href="highvis.php?vid={ $vis.vid }">{ $vis.title }</a></td>
    						</tr>
    					{ /foreach }
    				</table>
    			</div>
    		{ else }
    			<div id="vises"> 
    				<table width="100%">
    					<tr>
    						<td>No visualizations found.</td>
    					</tr>
    				</table>
    			</div>
    		{ /if }
    	</div> 
    	{ include file="parts/minipics.tpl" }
    	{ include file="parts/minivids.tpl" }
    	{ include file="parts/minishare.tpl" }
    { else }
        <div class="module">
    		<h1>Responses</h1>
    		{ if $vises }
    			<div id="vises">
    				<table width="100%">
    					{ foreach from=$vises item=vis }
    						<tr>
    							<td><a href="visdir.php?id={ $vis.vis_id }">{ $vis.name }</a></td>
    						</tr>
    					{ /foreach }
    				</table>
    			</div>
    		{ else }
    			<div id="vises"> 
    				<table width="100%">
    					<tr>
    						<td>No responses found.</td>
    					</tr>
    				</table>
    			</div>
    		{ /if }
    	</div>
	{ /if }
</div>
