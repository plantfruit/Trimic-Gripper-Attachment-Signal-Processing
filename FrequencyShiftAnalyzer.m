close all
clear

Fs = 48e3;

%=========================================================================
% List of Filenames
%=========================================================================
folderNameRubber = 'Rubber Data 2';
folderNameRep1 = 'Frequency Shift Data';
folderNameRep2 = 'Frequency Shift Data 2';
folderNameRep3 = 'Frequency Shift Data 3';
folderNameBal1 = 'Balloon Data 1';
folderNameTemp = 'Temp Data';
folderNameDrum = 'New Drum Data';

% Set of trials from August to November 2024
trial1 = ["1730331049205.txt", "1730331003808.txt", "1730331031753.txt"];
trial2 = ["1730476496038.txt", "1730476511144.txt", "1730476524624.txt", "1730476541462.txt", "1730476555685.txt", "1730476599311.txt", "1730476615029.txt", "1730476634725.txt", "1730476649361.txt"];
trial3 = ["1730491574427.txt", "1730491594834.txt", "1730491607450.txt"];
trial4 = ["1730560529856.txt", "1730560542996.txt", "1730560555493.txt", "1730560569234.txt", "1730560582467.txt", "1730560594689.txt", "1730560607779.txt", "1730560620694.txt", "1730560803005.txt", "1730560862432.txt", "1730560874028.txt", "1730560886208.txt", "1730560902153.txt", "1730560916468.txt", "1730560930480.txt", ...
    "1730561359542.txt", "1730561373999.txt", "1730561389056.txt", "1730561417792.txt", "1730561433098.txt", "1730561452172.txt", "1730561557288.txt", "1730561569756.txt", "1730561595768.txt", "1730561609289.txt", "1730561624429.txt", "1730561640554.txt"];
% Multipath trial (stuck a screw in the tube)
trial5 = ["1730930398876.txt", "1730930443641.txt", "1730930459618.txt", "1730930601942.txt", "1730930622761.txt", "1730930644241.txt", "1730930659815.txt", "1730930672817.txt", "1730930686914.txt"];
trial6 = ["1731018325860.txt", "1731018354200.txt", "1731018405628.txt", "1731018429357.txt", "1731018445526.txt", "1731018461303.txt", "1731018571304.txt", "1731018495255.txt", "1731018510415.txt"];
% Different orientations
trial7 = ["1731445126624.txt", "1731445149634.txt", "1731445209138.txt", "1731445221688.txt", "1731445354964.txt", "1731445367811.txt", "1731445379766.txt", "1731445396879.txt"];
% 2 cm one trial test
trial8 = ["1731453463107.txt", "1731454238816.txt", "1731454251965.txt", "1731454265241.txt", "1731454279159.txt", "1731454292718.txt"];
% In-between data (0.5 cm markings, from 1.5 - 8.5)
trial9 = ["1731529402223.txt", "1731529438616.txt", "1731534832714.txt", "1731529474241.txt", "1731529609908.txt", "1731529634462.txt", "1731529669092.txt", "1731537776898.txt" ...
    , "1731530036866.txt", "1731530052456.txt", "1731530075473.txt", "1731530099816.txt", "1731530195132.txt", "1731530210847.txt", "1731530287300.txt", "1731530287311.txt"];
% Data from the long tube (26 cm). 2 replication each trials for 2, 7, 9, 13, 17, 19, and 24
trial10 = ["1731707071552.txt", "1731707093906.txt", "1731707335106.txt", "1731707358105.txt", ...
    "1731707358106.txt", "1731707358107.txt", "1731707373478.txt", "1731707388517.txt", "1731707496247.txt", "1731707496248.txt", "1731707496246.txt", "1731707515626.txt", ...
      "1731707527950.txt", "1731707539465.txt"];
merge1and9 = ["1730476496038.txt", "1730560529856.txt", "1730560542996.txt", "1730560555493.txt",...
    "1730476649361.txt", "1730561609289.txt", "1730561624429.txt", "1730561640554.txt"];

% 2nd block of replication trials (December 2024)
% Tube mic sealed with tape
% 10 trials per each distance
% 1 cm
rep2_1 =    ["1733257308959.txt", "1733257367937.txt", "1733257402209.txt", "1733257415287.txt", "1733257428983.txt", "1733257449593.txt", "1733257464139.txt", "1733257489642.txt", "1733257503364.txt", "1733265676812.txt"];
% 1.5 cm
rep2_1d5 =  ["1733257572725.txt", "1733257592949.txt", "1733257607485.txt", "1733257621046.txt", "1733257646631.txt", "1733257663810.txt", "1733257680398.txt", "1733257696509.txt", "1733257720987.txt", "1733265688869.txt"];
% 2 cm
rep2_2 =    ["1733258041049.txt", "1733258054057.txt", "1733258082014.txt", "1733258094440.txt", "1733258108191.txt", "1733258121284.txt", "1733258133683.txt", "1733258145256.txt", "1733258159558.txt", "1733265699774.txt"];
% 2.5 cm
rep2_2d5 =  ["1733258390062.txt", "1733258402093.txt", "1733258414233.txt", "1733258442105.txt", "1733258476773.txt", "1733258487528.txt", "1733258501633.txt", "1733258513081.txt", "1733258534135.txt", "1733265720989.txt"];
% 3 cm
rep2_3 =    ["1733258721996.txt", "1733258960321.txt", "1733258972711.txt", "1733258987865.txt", "1733259006845.txt", "1733259022292.txt", "1733259096013.txt", "1733259109454.txt", "1733259121520.txt", "1733265731609.txt"];
% 3.5 cm
rep2_3d5 =  ["1733259138094.txt", "1733259150201.txt", "1733259161799.txt", "1733259182607.txt", "1733259192952.txt", "1733259332547.txt", "1733259343661.txt", "1733259353631.txt", "1733259364035.txt", "1733265741353.txt"];
% 4 cm
rep2_4 =    ["1733259396975.txt", "1733259445277.txt", "1733259457942.txt", "1733259468596.txt", "1733259491208.txt", "1733259503349.txt", "1733259514204.txt", "1733259525669.txt", "1733259538461.txt", "1733265758903.txt"];
% 4.5 cm
rep2_4d5 =  ["1733259629108.txt", "1733259642484.txt", "1733259654382.txt", "1733259670181.txt", "1733259681428.txt", "1733259692274.txt", "1733259703454.txt", ".1733259715202txt", "1733259726565.txt", "1733265768464.txt"];
% 5 cm
rep2_5 =    ["1733259887718.txt", "1733259961576.txt", "1733260003729.txt", "1733260015242.txt", "1733260069047.txt", "1733260090137.txt", "1733260100765.txt", "1733260111828.txt", "1733260139372.txt", "1733265781806.txt"];
% 5.5 cm
rep2_5d5 =  ["1733260356334.txt", "1733260380465.txt", "1733260391569.txt", "1733260402844.txt", "1733260415840.txt", "1733260427002.txt", "1733260443106.txt", "1733260454385.txt", "1733260466157.txt", "1733265792894.txt"];
% 6 cm
rep2_6 =    ["1733260709128.txt", "1733260719931.txt", "1733262100180.txt", "1733262111604.txt", "1733262129792.txt", "1733262148541.txt", "1733262161117.txt", "1733262178277.txt", "1733262207021.txt", "1733265809993.txt"];
% 6.5 cm
rep2_6d5 =  ["1733262357758.txt", "1733262368655.txt", "1733262379378.txt", "1733262394193.txt", "1733262406781.txt", "1733262419168.txt", "1733262435980.txt", "1733262447742.txt", "1733262459740.txt", "1733265828229.txt"];
% 7 cm
rep2_7 =    ["1733262791702.txt", "1733262802308.txt", "1733262812655.txt", "1733262823335.txt", "1733262835042.txt", "1733262849580.txt", "1733262860227.txt", "1733262870331.txt", "1733262880626.txt", "1733266008763.txt"];
% 7.5 cm
rep2_7d5 =  ["1733262893052.txt", "1733262917551.txt", "1733262931931.txt", "1733262942654.txt", "1733262974270.txt", "1733262986476.txt", "1733262997190.txt", "1733263009949.txt", "1733263022340.txt", "1733266019834.txt"];
% 8 cm
rep2_8 =    ["1733263084067.txt", "1733263105815.txt", "1733263117174.txt", "1733263128717.txt", "1733263139528.txt", "1733263150590.txt", "1733263161169.txt", "1733263171531.txt", "1733263181909.txt", "1733266030842.txt"];
% 8.5 cm
rep2_8d5 =  ["1733263235441.txt", "1733263248800.txt", "1733263258751.txt", "1733263274396.txt", "1733263316972.txt", "1733263330243.txt", "1733263343267.txt", "1733266041443.txt", "1733266055478.txt", "1733266078908.txt"];
% 9 cm
rep2_9 =    ["1733263662886.txt", "1733263682342.txt", "1733263696520.txt", "1733263718579.txt", "1733263730886.txt", "1733263743836.txt", "1733263755074.txt", "1733263766119.txt", "1733263786384.txt", "1733263799609.txt"];

% 3rd block of replication trials (December 7, 2024)
% Tube mic sealed with putty
% 10 trials per each distance

% 1 cm
rep3_1 =    ["1733606168576.txt", "1733606184225.txt", "1733608834671.txt", "1733608848078.txt", "1733608866621.txt", "1733608878425.txt", "1733608891291.txt", "1733609057360.txt", "1733609068962.txt", "1733609100796.txt"];
% 1.5 cm
rep3_1d5 =  ["1733612143262.txt", "1733612194774.txt", "1733612205411.txt", "1733612222070.txt", "1733612233684.txt", "1733612259446.txt", "1733612270187.txt", "1733612494651.txt", "1733612504601.txt", "1733612546903.txt"];
% 2 cm
rep3_2 =    ["1733613229771.txt", "1733613241215.txt", "1733613253078.txt", "1733613263064.txt", "1733613278997.txt", "1733613289536.txt", "1733613301294.txt", "1733613423334.txt", "1733613446930.txt", "1733613486076.txt"];
% 2.5 cm
rep3_2d5 =  ["1733614200081.txt", "1733614218449.txt", "1733614228204.txt", "1733614238886.txt", "1733614250385.txt", "1733614262202.txt", "1733614272716.txt", "1733614283924.txt", "1733614298553.txt", "1733614310470.txt"];
% 3 cm
rep3_3 =    ["1733614622855.txt", "1733614636029.txt", "1733614692257.txt", "1733614703547.txt", "1733614758579.txt", "1733614778745.txt", "1733614806484.txt", "1733614818216.txt", "1733614863895.txt", "1733614904272.txt"];
% 3.5 cm
rep3_3d5 =  ["1733615926578.txt", "1733615939472.txt", "1733615951648.txt", "1733615966447.txt", "1733615978640.txt", "1733615992035.txt", "1733616010824.txt", "1733616025831.txt", "1733616044270.txt", "1733616081303.txt"];
% 4 cm
rep3_4 =    ["1733617132817.txt", "1733617143613.txt", "1733617155572.txt", "1733617167354.txt", "1733617179920.txt", "1733617191503.txt", "1733617202542.txt", "1733617218308.txt", "1733617230524.txt", "1733617240410.txt"];
% 4.5 cm
rep3_4d5 =  ["1733617761735.txt", "1733617774345.txt", "1733617795205.txt", "1733617828557.txt", "1733617845796.txt", "1733617857859.txt", "1733617871362.txt", "1733617883210.txt", "1733617897639.txt", "1733617951133.txt"];
% 5 cm
rep3_5 =    ["1733617965796.txt", "1733617978496.txt", "1733617989703.txt", "1733618001327.txt", "1733618055620.txt", "1733618069358.txt", "1733618080989.txt", "1733618092470.txt", "1733618104194.txt", "1733618116377.txt"];
% 5.5 cm
rep3_5d5 =  ["1733619096482.txt", "1733619112317.txt", "1733619128544.txt", "1733619150516.txt", "1733619167202.txt", "1733619181399.txt", "1733619199488.txt", "1733619217358.txt", "1733619229684.txt", "1733619243411.txt"];
% 6 cm
rep3_6 =    ["1733619662788.txt", "1733619675063.txt", "1733619687095.txt", "1733619710568.txt", "1733619736837.txt", "1733619749179.txt", "1733619764600.txt", "1733619775839.txt", "1733619792665.txt", "1733619803136.txt"];
% 6.5 cm
rep3_6d5 =  ["1733620446868.txt", "1733620458494.txt", "1733620494716.txt", "1733620508044.txt", "1733620519969.txt", "1733620531402.txt", "1733620549297.txt", "1733620574710.txt", "1733620586409.txt", "1733620597156.txt"];
% 7 cm
rep3_7 =    ["1733620657145.txt", "1733620710335.txt", "1733620738599.txt", "1733620750965.txt", "1733620778329.txt", "1733620797743.txt", "1733620811980.txt", "1733620823212.txt", "1733620834902.txt", "1733620846192.txt"];
% 7.5 cm
rep3_7d5 =  ["1733620925182.txt", "1733620938317.txt", "1733620951109.txt", "1733620975958.txt", "1733620989860.txt", "1733621002254.txt", "1733621014039.txt", "1733621025895.txt", "1733621050583.txt", "1733621067799.txt"];
% 8 cm
rep3_8 =    ["1733621649136.txt", "1733621667014.txt", "1733621683414.txt", "1733621694804.txt", "1733621705233.txt", "1733621726643.txt", "1733621735916.txt", "1733621745521.txt", "1733621754881.txt", "1733621764324.txt"];
% 8.5 cm
rep3_8d5 =  ["1733621807328.txt", "1733621817733.txt", "1733621827535.txt", "1733621837212.txt", "1733621846249.txt", "1733621857642.txt", "1733621868355.txt", "1733621887367.txt", "1733621897045.txt", "1733621906697.txt"];
% 9 cm
rep3_9 =    ["1733622031955.txt", "1733622050493.txt", "1733622060906.txt", "1733622071251.txt", "1733622081388.txt", "1733622091693.txt", "1733622101320.txt", "1733622111573.txt", "1733622121827.txt", "1733622131721.txt"];

balloonTest = ["1734640260329.txt"];
% 
% Top left
bal1_1 = ["1734797290567.txt", "1734797306414.txt", "1734797319709.txt", "1734797332979.txt", "1734797346808.txt"];
% Middle 
bal1_2 = ["1734797366568.txt", "1734797380472.txt", "1734797393348.txt", "1734797406341.txt", "1734797419146.txt"];
% Bottom right
bal1_3 = ["1734797431911.txt", "1734797445037.txt", "1734797463291.txt", "1734797508850.txt", "1734797521087.txt"];

piezoTube = ["1735665932961.txt"];
piezoTubeAndDisk = ["1735665932961.txt", "1735666155475.txt"];

% Drum test
drum1_1 = ["1736179476940.txt", "1736179537498.txt", "1736179568301.txt", "1736179585002.txt", "1736179601556.txt"];
drum1_2 = ["1736179620062.txt", "1736179636766.txt", "1736179652289.txt", "1736179668089.txt", "1736179684392.txt"];
drum1_3 = ["1736179700946.txt", "1736179718127.txt", "1736179733140.txt", "1736179748713.txt", "1736179819758.txt"];
drum1_4 = ["1736179834926.txt", "1736179850173.txt", "1736179866201.txt", "1736179881459.txt", "1736179910281.txt"];
drum1_5 = ["1736179928649.txt", "1736179944848.txt", "1736179960535.txt", "1736179976558.txt", "1736179992521.txt"];
drum1_6 = ["1736180010806.txt", "1736180026039.txt", "1736180041232.txt", "1736180056211.txt", "1736180071130.txt"];
drum1_7 = ["1736180085551.txt", "1736180101919.txt", "1736180119840.txt", "1736180137114.txt", "1736180152745.txt"];
drum1_8 = ["1736180172069.txt", "1736180186706.txt", "1736180202292.txt", "1736180220756.txt", "1736180294145.txt"];
drum1_9 = ["1736180340171.txt", "1736180355668.txt", "1736180377151.txt", "1736180395786.txt", "1736180426334.txt"];

drum2_1 = ["1736206758072.txt", "1736206779867.txt", "1736206797003.txt", "1736206813112.txt", "1736206834856.txt"];
drum2_2 = ["1736206870419.txt", "1736206890737.txt", "1736206917847.txt", "1736206935504.txt", "1736206954021.txt"];
drum2_3 = ["1736207012625.txt", "1736207033411.txt", "1736207050614.txt", "1736207067985.txt", "1736207084645.txt"];
drum2_4 = ["1736207118349.txt", "1736207137465.txt", "1736207153597.txt", "1736207174282.txt", "1736207199458.txt"];
drum2_5 = ["1736207223190.txt", "1736207238950.txt", "1736207256616.txt", "1736207273583.txt", "1736207289405.txt"];
drum2_6 = ["1736207318529.txt", "1736207335679.txt", "1736207398366.txt", "1736207414681.txt", "1736207430963.txt"];
drum2_7 = ["1736207458419.txt", "1736207486827.txt", "1736207503302.txt", "1736207519759.txt", "1736207536786.txt"];
drum2_8 = ["1736207565284.txt", "1736207588105.txt", "1736207605984.txt", "1736207623409.txt", "1736207640309.txt"];
drum2_9 = ["1736207665249.txt", "1736207683168.txt", "1736207700385.txt", "1736207718971.txt", "1736207736622.txt"];

bal3_1 = ["1736209653073.txt", "1736209685081.txt", "1736209712189.txt", "1736209729326.txt", "1736209746027.txt"]; 
bal3_2 = ["1736209783120.txt", "1736209806325.txt", "1736209822066.txt", "1736209837923.txt", "1736209865213.txt"];
bal3_3 = ["1736209890081.txt", "1736209905129.txt", "1736209920058.txt", "1736209935883.txt", "1736209952108.txt"];
bal3_4 = ["1736210003445.txt", "1736210024928.txt", "1736210041603.txt", "1736210057493.txt", "1736210073850.txt"];
bal3_5 = ["1736210112952.txt", "1736210135245.txt", "1736210152747.txt", "1736210171977.txt", "1736210198386.txt"];
bal3_6 = ["1736210231101.txt", "1736210247208.txt", "1736210263043.txt", "1736210279555.txt", "1736210295612.txt"];
bal3_7 = ["1736210327324.txt", "1736210343231.txt", "1736210358628.txt", "1736210386331.txt", "1736210402480.txt"];
bal3_8 = ["1736210429865.txt", "1736210446991.txt", "1736210463155.txt", "1736210481783.txt", "1736210497697.txt"];
bal3_9 = ["1736210526902.txt", "1736210542446.txt", "1736210564863.txt", "1736210580777.txt", "1736210595922.txt"];

grip1_1 = ["1736372750593.txt", "1736372765964.txt", "1736372778798.txt", "1736372793711.txt", "1736372806829.txt"];
grip1_2 = ["1736373003706.txt", "1736373017901.txt", "1736373028749.txt", "1736373040532.txt", "1736373051279.txt"];
grip1_3 = ["1736373469551.txt", "1736373486777.txt", "1736373499939.txt", "1736373513503.txt", "1736373526123.txt"];
grip1_4 = ["1736373567205.txt", "1736373612368.txt", "1736373625354.txt", "1736373640595.txt", "1736373652963.txt"];
grip1_5 = ["1736373670934.txt", "1736373687745.txt", "1736373700739.txt", "1736374240317.txt", "1736374257312.txt"];
grip1_6 = ["1736374280310.txt", "1736374297439.txt", "1736374311334.txt", "1736374324487.txt", "1736374343151.txt"];
grip1_7 = ["1736374441993.txt", "1736374455439.txt", "1736374475149.txt", "1736374488228.txt", "1736374506919.txt"];
grip1_8 = ["1736374551055.txt", "1736374564216.txt", "1736374576568.txt", "1736374591039.txt", "1736374608325.txt"];
grip1_9 = ["1736374636415.txt", "1736374657525.txt", "1736374677625.txt", "1736374714177.txt", "1736374728991.txt"];

% With the new, more tense balloon wrap
grip2_1 = ["1736460390693.txt", "1736460419158.txt", "1736460459214.txt", "1736460472185.txt", "1736460494026.txt"]; 
grip2_2 = ["1736460536304.txt", "1736460551270.txt", "1736460603251.txt", "1736460639662.txt", "1736460654269.txt"]; 
grip2_3 = ["1736460678327.txt", "1736460691563.txt", "1736460704414.txt", "1736460720806.txt", "1736460734293.txt"];
grip2_4 = ["1736460787893.txt", "1736460805956.txt", "1736460817381.txt", "1736460829582.txt", "1736460849039.txt"];
grip2_5 = ["1736460875813.txt", "1736460887053.txt", "1736460899137.txt", "1736460910653.txt", "1736460922670.txt"];
grip2_6 = ["1736460947155.txt", "1736460959758.txt", "1736460974439.txt", "1736460988336.txt", "1736460999818.txt"];
grip2_7 = ["1736461171852.txt", "1736461184069.txt", "1736461196911.txt", "1736461207583.txt", "1736461231241.txt"];
grip2_8 = ["1736461251283.txt", "1736461262171.txt", "1736461272024.txt", "1736461282654.txt", "1736461293705.txt"];
grip2_9 = ["1736461321660.txt", "1736461359220.txt", "1736461369808.txt", "1736461385088.txt", "1736461403391.txt"];

% 3-mic data
trimic1 = ["1736723732057.txt", "1736723757014.txt", "1736723774206.txt", "1736723788935.txt", "1736723804757.txt", ...
    "1736723991945.txt", "1736724008567.txt", "1736724020607.txt", "1736724031754.txt", "1736724043367.txt", ...
    "1736724394118.txt", "1736724408776.txt", "1736724419739.txt", "1736724430661.txt", "1736724441582.txt", ...
    "1736724599382.txt", "1736724610936.txt", "1736724622425.txt", "1736724634740.txt", "1736724646120.txt", ...
    "1736724800777.txt", "1736724812013.txt", "1736724823024.txt", "1736724834202.txt", "1736724845223.txt", ...
    "1736725047271.txt", "1736725060098.txt", "1736725071272.txt", "1736725082162.txt", "1736725092919.txt", ...
    "1736725377076.txt", "1736725388302.txt", "1736725400812.txt", "1736725425810.txt", "1736725437686.txt", ...
    "1736725582529.txt", "1736725593490.txt", "1736725604618.txt", "1736725615470.txt", "1736725626256.txt", ...
    "1736725946373.txt", "1736725961538.txt", "1736725972679.txt", "1736725984356.txt", "1736725998495.txt"];

trimic2 = ["1645876031082.txt", "1645876043172.txt", "1645876057015.txt", "1645876069480.txt", "1645876082395.txt", ...
    "1645876243670.txt", "1645876257084.txt", "1645876268884.txt", "1645876280873.txt", "1645876293271.txt", ...
    "1645876641005.txt", "1645876653206.txt", "1645876664658.txt", "1645876679956.txt", "1645876694063.txt", ...
    "1645876859791.txt", "1645876872605.txt", "1645876884286.txt", "1645876896741.txt", "1645876910185.txt", ...
    "1645877047502.txt", "1645877087575.txt", "1645877100097.txt", "1645877112944.txt", "1645877124626.txt", ...
    "1645877292632.txt", "1645877304636.txt", "1645877315267.txt", "1645877326132.txt", "1645877337171.txt", ...
    "1645877637349.txt", "1645877648286.txt", "1645877659707.txt", "1645877670578.txt", "1645877681265.txt", ...
    "1645877828283.txt", "1645877839679.txt", "1645877850458.txt", "1645877868835.txt", "1645877882123.txt", ...
    "1645878251648.txt", "1645878262368.txt", "1645878284196.txt", "1645878296325.txt", "1645878307356.txt"];

trimic3 = ["1736723909000.txt", "1736723922366.txt", "1736723948773.txt", "1736723963201.txt", "1736723976993.txt", ...
    "1736724120098.txt", "1736724132013.txt", "1736724144203.txt", "1736724158339.txt", "1736724170704.txt", ...
    "1736724519829.txt", "1736724530828.txt", "1736724542392.txt", "1736724554313.txt", "1736724566004.txt", ...
    "1736724736817.txt", "1736724752898.txt", "1736724765356.txt", "1736724777470.txt", "1736724790963.txt", ...
    "1736724985168.txt", "1736724997746.txt", "1736725010642.txt", "1736725024819.txt", "1736725036492.txt", ...
    "1736725161759.txt", "1736725172646.txt", "1736725184601.txt", "1736725196490.txt", "1736725207916.txt", ...
    "1736725523938.txt", "1736725536086.txt", "1736725547771.txt", "1736725559155.txt", "1736725571453.txt", ...
    "1736725714450.txt", "1736725732358.txt", "1736725745357.txt", "1736725902973.txt", "1736725924758.txt", ...
    "1736726164201.txt", "1736726180033.txt", "1736726194087.txt", "1736726217065.txt", "1736726252959.txt"];

%=========================================================================
% Beginning of Analysis Portion of Script
%=========================================================================

% Select the dataset to analyze
fileNames = trimic3;
folderPath = folderNameDrum;

% Select the distance trial to analyze
i = 4;

% "Switches" to control the script operation
isAnimated = false;
plotIntermediates = false;
clickProceed = false;
calculateAmplitudes = false;
findResonances = true;

% More control switches (copied over from the FFT run script)
windowModifier = 0;
transmitSignal = [0 0 0 0 0 1 0 0 0 0 0];
minpeakHeight = 10;
gapTime = 0.05;
pulseLength = 300;
smoothingFactor = 5; % 5 - tube. 10 - balloon
t = length(transmitSignal);
% For 26 cm tube -> make this 0
% For 10 cm tube -> make this 2 
minPeakProminence = 2; 
figDims = [3 2];
%increments = [0.24 0.43];

% List of intermediate level time points which are used to find and
% determine the frequencies before the press and during the press.
% Expressed in units of percentage
timeIncrements = [0.22 0.7 0.77];

% Change these depending on the specific trial (we've already manually
% collected this resonance frequency data earlier)
knownFrStart = [4202
    5802
    7603
    9384
    11145
    12825
    14486
    16067
    17687];
knownFrPress = [4642
    4642
    6643
    8724
    10745
    12785
    14806
    16807
    18728];

% Go to the directory containing data files (other directories are
% commented out
cd(folderPath);

maxFreqs = zeros(length(fileNames), 192);
%for i = 1:3

% % Amplitude
% ampsStart = zeros(1, length(knownFrStart));
% ampsPress = zeros(1, length(knownFrPress));
% ampsDiff = zeros(1, length(knownFrPress));

% Read the specified file
%fileName = fileNames(i);
%micData = readmatrix(fileName);
% Excise trailing zeros
%micData = micData(1:find(micData, 1, 'last'));

% Frame rate determines the segment length that we extract for each FFT in
% analysis
%frameRate = 0.05;
%L = length(micData)/Fs;

% Large arrays that have been pre-allocated to store results calculated
% during the primary loop
allFreqShifts = zeros(length(fileNames), 8);
allStartFreqs = zeros(length(fileNames), 8);
allPressFreqs = zeros(length(fileNames), 8);
allAmpStartLevels = zeros(length(fileNames), 8);
allAmpPressLevels = zeros(length(fileNames), 8);
allAmpAreas = zeros(length(fileNames), 2);

allStartFFT = zeros(length(fileNames), 100);
allPressFFT = zeros(length(fileNames), 100);
allpwelchStarts = zeros(length(fileNames), 100);
allpwelchPresses = zeros(length(fileNames), 100);
allDiffStarts = zeros(length(fileNames), 100);
allDiffPresses = zeros(length(fileNames), 100);

for k = 1:length(fileNames)
    fileName = fileNames(k);
    micData = readmatrix(fileName);

    [r, lags] = xcorr(transmitSignal, micData);
    [peaks, peakLocations] = findpeaks(r, 'MinPeakHeight', minpeakHeight, 'MinPeakDistance', gapTime * Fs); % length(t) / 2);
    % MinPeakDistance: .wav - 300, .mp3 - 10

    % figure
    % plot(r)
    % hold on
    % scatter(peakLocations, peaks)

    peakTimes = -lags(peakLocations);
    peakTimes = abs(sort(peakTimes));
    chirpIndex = 1; % Maybe change later?

    startFreqs = zeros(1,8);
    
    pressFreqs = zeros(1,8);

    figure
    % Iterate through all delta pulses detected by the cross-correlation
    for i = 1:length(peakTimes)
        chirpIndex = i;
        

        % Extract the pulse and its reflections
        % Do this only at the specified time increments: roughly quarter of
        % the way through (resting state) or halfway through (pressdown
        % state)
        if (i == round(timeIncrements(1) * length(peakTimes)) || i == round(timeIncrements(2) * length(peakTimes)))
            % Extract delta pulse by taking a small amount of time before and
            % after it
            chirpSegment = micData(peakTimes(chirpIndex) - pulseLength*1 + windowModifier : peakTimes(chirpIndex) + pulseLength*1.5 + windowModifier  - 1);
            subplot(figDims(1), figDims(2), 1); hold on; graph = plot(chirpSegment); %hold on; xline((peakTimes(chirpIndex) + windowModifier) / Fs, 'b-'); xline((peakTimes(chirpIndex) /Fs + (length(t) + windowModifier  - 1) /Fs), 'r-');

            if (k <= length(fileNames)/2)
                graph.Color = 'b';
            else
                graph.Color = 'r';
            end

            % figure
            % plot(chirpSegment)
            % xlabel("Time (s)"); ylabel("Amplitude"); title("Chirp Segment, " + fileName)

            % Perform FFT of the chirp segment
            micDataF = mag2db(abs(fft(chirpSegment))); 
            f = linspace(0,Fs, length(micDataF));

            % Plot frequency response
            if (findResonances == true)
                % Plot FFT before smoothing
                subplot(figDims(1), figDims(2), 2); plot(f, micDataF); xlim([0 22000]); ylim([0 140])

                % Smooth out noise and "false peaks" using an average filter
                smoothMicF = smooth(micDataF, smoothingFactor);

                % Window the FFT graph so only the first 8 (or possibly 9)
                % resonances are displayed
                resWindow = zeros(1,2);

                if (i == round(timeIncrements(1) * length(peakTimes)))
                    windF1= 3100;
                else
                    windF1 = 2900;
                end                
                [~, resWindow(1)] = min(abs(f - 5000)); % - windF1
                [~, resWindow(2)] = min(abs(f - 21000));
                windowedSmooth = smoothMicF(resWindow(1):resWindow(2));

                % Find the resonance frequencies
                [peakVals, peakLocs] = findpeaks(windowedSmooth, "MinPeakProminence", minPeakProminence, 'MinPeakDistance', 8);

                % Plot comparison of unsmoothed and the smoothed FFT
                % figure
                % subplot(2,1,1)
                % plot(f, micDataF); xlim([0 20e3]); ylim([0 140])
                % subplot(2,1,2)
                % plot(f, smoothMicF); xlim([0 20e3]); ylim([0 140])

                resonanceFrequencies = f(peakLocs);
                realResonanceFrequencies = resonanceFrequencies + f(resWindow(1));

                % For reducing number of FFT values/features (?)
                windowedF = smoothMicF(resWindow(1):resWindow(2)); %micDataF(resWindow(1):resWindow(2));
                powerEstimate = pwelch(chirpSegment, 64);
                fftDerivative = diff(windowedSmooth); %diff(windowedF);

                % Plot FFT from initial stage
                if (i == round(timeIncrements(1) * length(peakTimes)))
                    subplot(figDims(1), figDims(2), 3)
                    hold on
                    graph = plot(f, micDataF);
                    xlim([0 22000]); ylim([0 140])
                    
                    startFreqs(1:length(resonanceFrequencies)) = realResonanceFrequencies;
                    allStartFreqs(k, 1:length(startFreqs)) = startFreqs;
                    allAmpStartLevels(k,1:length(peakVals)) = peakVals;
                    allStartFFT(k, 1:length(windowedF)) = windowedF.';
                    allpwelchStarts(k, 1:length(powerEstimate)) = powerEstimate.';
                    allDiffStarts(k, 1:length(fftDerivative)) = fftDerivative.';
                    %allAmpAreas(k, 1) = trapz(windowedSmooth(round(length(windowedSmooth)* 0.6):end));
                end

                % Plot FFT in pressdown stage
                if (i == round(timeIncrements(2) * length(peakTimes)))
                    subplot(figDims(1), figDims(2), 4)
                    hold on
                    graph = plot(f, micDataF);
                    xlim([0 22000]); ylim([0 140])

                    
                    pressFreqs(1:length(resonanceFrequencies)) = realResonanceFrequencies;
                    allPressFreqs(k, 1:length(pressFreqs)) = pressFreqs; 

                    allFreqShifts(k, 1:max([length(pressFreqs) length(startFreqs)])) = [pressFreqs zeros(1, length(startFreqs) - length(pressFreqs))] ...
                        - [startFreqs zeros(1, length(pressFreqs) - length(startFreqs))];
                    % Store the amplitude levels from press down stage
                    allAmpPressLevels(k,1:length(peakVals)) = peakVals;
                    allPressFFT(k, 1:length(windowedF)) = windowedF.';
                    allpwelchPresses(k, 1:length(powerEstimate)) = powerEstimate.';
                    allDiffPresses(k, 1:length(fftDerivative)) = fftDerivative.';
                    %allAmpAreas(k, 2) = trapz(windowedSmooth(round(length(windowedSmooth)* 0.6):end));
                end

                % figure
                subplot(figDims(1), figDims(2),5)
                plot(f, micDataF); hold on; scatter(resonanceFrequencies + f(resWindow(1)), peakVals); xlim([0 20e3]); ylim([0 140])
                subplot(figDims(1), figDims(2), 6)
                plot(f(1:resWindow(2)-resWindow(1) + 1), windowedSmooth); hold on; scatter(resonanceFrequencies, peakVals)
                ylim([0 140])

                % Print the resonance frequencies that we found

                %format short g
                %realResonanceFrequencies'
            end

            xlabel("Frequency (Hz)"); ylabel("Magnitude");
            title("Microphone Data, Frequency-Domain, " + fileName)
            if (k <= length(fileNames)/2)
                graph.Color = 'b';
            else
                graph.Color = 'r';
            end
        end
    end
end

% figure
%
% counter = 1;
%
% micDataF = mag2db(abs(fft(micData)));
%
% %f = linspace(0, Fs, length(micDataF));
%
% con = zeros(3, round(L/frameRate));
%
% maxJ = round(L/frameRate);
%
% %    if (i == 1)
% for j = 1:L/frameRate
%     if (counter + Fs * frameRate - 1 < length(micData))
%         micDataF = mag2db(abs(fft(micData(counter:counter + Fs * frameRate - 1))));
%     else
%         micDataF = mag2db(abs(fft(micData(counter:end))));
%     end
%
%     f = linspace(0, Fs, length(micDataF));
%
%     %[peakVal, peakLoc] = max(micDataF(1:400), [], 'all');
%     %maxFreqs(i,j) = f(peakLoc);
%     %disp(maxFreqs(i,j))
%
%     figure(1)
%     plot(f, micDataF);
%     %xlim([0 2 * length(micDataF)/10]); ylim([0 140])
%     xlim([0 20e3]); ylim([0 140])
%     title(fileName)
%
%     % Show the FFT at notable increments
%     if (plotIntermediates == true && (j == round(maxJ * timeIncrements(1)) || j == round(maxJ * timeIncrements(2)) || j == round(maxJ * timeIncrements(3))))
%         figure
%         plot(f, micDataF); xlim([0 20e3]); ylim([0 140])
%         title(i + " " + j)
%     end
%
%     % Find the y-value of FFT at each specific resonance frequency, so we
%     % can manually calculate the differences in amplitude later
%     % Also, calculate the peaks (aka frequency values of the resonances)
%
%     % Prior to press on tube
%     if (j == round(maxJ * timeIncrements(1)) || j == round(maxJ * timeIncrements(2)))
%
%         if (findResonances == true)
%             % Smooth out noise and "false peaks" using an average filter
%             smoothMicF = smooth(micDataF, 10);
%
%             % Window the FFT graph so only the first 8 (or possibly 9)
%             % resonances are displayed
%             resWindow = zeros(1,2);
%             [~, resWindow(1)] = min(abs(f - 3300));
%             [~, resWindow(2)] = min(abs(f - 18000));
%             windowedSmooth = smoothMicF(resWindow(1):resWindow(2));
%
%             [peakVals, peakLocs] = findpeaks(windowedSmooth, "MinPeakProminence", 2);
%
%             % Plot comparison of unsmoothed and the smoothed FFT
%             % figure
%             % subplot(2,1,1)
%             % plot(f, micDataF); xlim([0 20e3]); ylim([0 140])
%             % subplot(2,1,2)
%             % plot(f, smoothMicF); xlim([0 20e3]); ylim([0 140])
%
%             resonanceFrequencies = f(peakLocs);
%
%             figure
%             subplot(2,1,1)
%             plot(f, micDataF); hold on; scatter(resonanceFrequencies + f(resWindow(1)), peakVals); xlim([0 20e3]); ylim([0 140])
%             subplot(2,1,2)
%             plot(f(1:resWindow(2)-resWindow(1) + 1), windowedSmooth); hold on; scatter(resonanceFrequencies, peakVals)
%             ylim([0 140])
%
%             % Print the resonance frequencies that we found
%             realResonanceFrequencies = resonanceFrequencies + f(resWindow(1));
%             format short g
%             realResonanceFrequencies'
%         end
%
%         if (calculateAmplitudes == true)
%             for k = 1:length(knownFrStart)
%                 [~, idx] = min(abs(f - knownFrStart(k)));
%                 % Then use this index to get the corresponding amplitude in y-axis
%                 % of FFT
%                 ampsStart(k) = micDataF(idx);
%             end
%         end
%
%         if (calculateAmplitudes == true)
%             for k = 1:length(knownFrPress)
%                 [~, idx] = min(abs(f - knownFrPress(k)));
%                 % Then use this index to get the corresponding amplitude in y-axis
%                 % of FFT
%                 ampsPress(k) = micDataF(idx);
%             end
%         end
%     end
%
%     %[peakVals, peakLocs] = findpeaks(micDataF(1:400), 'MinPeakDistance', 50);
%     %hold on; scatter(f(peakLocs), peakVals); hold off;
%
%     if (isAnimated == true)
%         pause(frameRate)
%     end
%
%     if (clickProceed == true)
%         waitforbuttonpress
%     end
%
%     counter = counter + Fs * frameRate;
% end



%    end
% figure
% spectrogram(micData, Fs/100, 0, [], Fs)
% title(fileName)
% end

cd ..

% Calculate the amplitude difference after frequency shift of the
% resonances
% ampsDiff = ampsPress - ampsStart;
% 
% ampsStart'
% ampsPress'
% ampsDiff'

% Deprecated code

%
%
% fileNames = ["acp1.mat", "acp2.mat", "acp3.mat", "acp4.mat", "acp5.mat", "acp6.mat", "acp7.mat", "acp8.mat", "acp9.mat"];
% numHarmonics = 8;
% vs = 343;
% L = 0.102;
%
% r1 = [1538.74 2992.34 4679.28 6703.6 10957.2 12480.2];
% r2 = [1705.86 3219.37 4994.59 11486.9 13407.2 15103.6 17140.5];
% r3 = [3418.02 5606.31 8217.12 9257.66];
% r4 = [3818.47 6482.88 12086];
% r5 = [4553.15 8611.26 12492.8 16043.2];
% r6 = [3972.97 6987.39 13445 16286];
% r7 = [3518.92 5871.17 8570.27 11228.4 13826.6 16188.3];
% r8 = [3332.88 5275.23 7624.32 9986.04 12250 17039.6];
% r9 = [2932.42 4628.83 6618.47 8686.94 10676.6];
%
% harmonicFreqs = zeros(1, numHarmonics);
% % Copied over from the addHarmonicFrequencies() function
% for i = 1:numHarmonics
%     % Calculate frequency at this harmonic using formula for closed
%     % ended tube, where frequency = (2 * speed of sound) / (2 * tube
%     % length)
%     harmonicFreqs(i) = (i * vs) / (2 * L);
% end
%
% figure
% plot(r1)
% hold on
% %plot(r2)
% hold on
% plot(r3)
% hold on
% %plot(r4)
% hold on
% plot(r5)
% hold on
% %plot(r6)
% hold on
% plot(r7)
% hold on
% %plot(r8)
% hold on
% plot(r9)
% hold on
% plot(harmonicFreqs)
%
% legend([fileNames "Theoretical Resonances"])