 <html>
<head>
<title>iSenseDev Automated Testing</title>
<link rel="stylesheet" type="text/css" href="apitest.css" />
</head>
<body>

<?php

//HTTP codes
// 200 - OK
// 400 - Bad Request
// 600 - Bad Reqest/Doesn't Exist

//Experiments:
// 0 has no data
// 1 is an open experiment
// 2 is a closed experiment
// 3 is a deleted experimetnt
// 346 has data

//Users:
// james.dalphond@gmail.com (password) - uid: 5


//To do:
//*** - getPeople
//*** - getSessions (deal with limits)
//*** - getExperiments (make sure you deal with limits)
//DONE! kc - low - getUserProfile
//DONE! kc - low - getExperimentByUser
//DONE! ar - low - getVisByUser
//DONE! ar - low - getSessionsByUser
//DONE! ar - low - getImagesByUser
//DONE! low - getVideosByUser
//jeremy email - putSessionData/updateSessionData
// uploadImageToExperiment
//jermey uses this one - uploadImageToSession
//skip for now - getDataSince

//DONE
// ******apitest-login.php******
// login

// ******apitest-get_general_info.php******
// getExperiments*
// getPeople*
// getVisualizations*
// getSessions


//DONE
// *****apitest-get_experiment_info.php****** 
// getExperimentFields
// getExperimentVisualizations
// getExperimentTags
// getExperimentVideos
// getExperimentImages

//DONE
// ******apitest-get_user_info.php******
// getUserProfile
// getExperimentByUser
// getVisByUser
// getSessionsByUser
// getImagesByUser
// getVideosByUser

// ******apitest-session.php******
// createSession
// uploadImageToSession*
// putSessionData*


// ******apitest-experiment.php******
// uploadImageToExperiment*



require_once('../../includes/config.php');



//Log in token used to authenticate a user
$session_key = null;

//Session id for experiment
$session_id = null;

//User id for logged in user
$uid = null;

function initialize(){
    global $db;
    echo "Setting experiment 1 to open...<br>";
    $result = $db->query('UPDATE experiments SET closed=0 WHERE experiment_id=1');
    
    if($result==1) {
        echo "Setting experiment 2 to closed...<br>";
        $result2 = $db->query('UPDATE experiments SET closed=1 WHERE experiment_id=2');
        if($result2 == 1){
            return true;
        }
    } else {
        return false;
    }
}



//--------------------------------------------------------------------------------------------------------------------
//Initialize
echo "<h1>Initialization</h1>";
//setting up closed and open experiments
echo "<h2>Initializing database....</h2>";
if(initialize()){
    echo "<div class='success'>SUCCESS</div>, Initialization completed!<br>";	
} else {
    echo "<div class='failure'>FAILURE</div>, Initialization failed!<br>";
}
echo "<hr>";


//--------------------------------------------------------------------------------------------------------------------


//Need to fix mysql error - user -1 has images


require_once('apitest-login.php');

require_once('apitest-get_general_info.php');

require_once('apitest-get_user_info.php');

require_once('apitest-session.php');

require_once('apitest-experiment.php');





?>
</body>
</html>