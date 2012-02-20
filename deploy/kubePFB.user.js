// ==UserScript==
// @name          Kube Photo-fail Blocker
// @namespace     http://www.muxxu.free.fr/kube/apps/pfb
// @include       http://kube.muxxu.com/
// @include       http://kube.muxxu.com/?*
// @description   Adds an HTML layer over the flash game to prevent from clicking on the photo button. Its visibility is automatically managed depending on the current coordinates and "P" state.
// ==/UserScript==

if (document.getElementById('swf_minimap') != null) {
	var swfRef, photoFailBlockerRef;
	var pEnabled = false;
	var onDangerousZone = true;
	var blockerId = "photoFailBlockerV2";
	swfRef = unsafeWindow.document.getElementById('swf_kube');
	
	photoFailBlockerRef= unsafeWindow.document.createElement('div');
	swfRef.appendChild(photoFailBlockerRef);
	var isChrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
	if(isChrome && swfRef.getElementsByTagName("embed")[0].getAttribute("wmode") != "direct") {
		swfRef.getElementsByTagName("embed")[0].setAttribute("wmode", "opaque");
		with (swfRef.parentNode) appendChild(removeChild(swfRef));
	}
	
	photoFailBlockerRef.innerHTML = "<div style=\"position: relative; z-index: 5; left: 10px; top: 10px; width: 47px; height: 50px; background-color: rgb(0, 0, 0); background-image: url('http://www.muxxu.free.fr/kube/images/noPhoto.jpg'); background-repeat: no-repeat; background-position: left top;\" id=\""+blockerId+"\" onmouseover=\"document.getElementById('filter').style.display='inline';\"><textarea style=\"display:none; width:46px; height:49px; overflow:hidden; font-size:8px; color:#ffffff; background-color:transparent; border:none;\" id=\"filter\" name=\"filter\" onmouseout=\"document.getElementById('filter').style.display='none';\" /></textarea></div>";
	
	function setCookie(name, value) {
		var expDate = new Date();
		expDate.setTime(expDate.getTime() + (365 * 24 * 3600 * 1000))
		unsafeWindow.document.cookie = name + "=" + escape(value) + ";expires=" + expDate.toGMTString()
	}
	
	function getCookie(nom) {
		deb = unsafeWindow.document.cookie.indexOf(nom + "=")
		if (deb >= 0) {
			deb += nom.length + 1
			fin = unsafeWindow.document.cookie.indexOf(";",deb)
			if (fin < 0){
				fin = unsafeWindow.document.cookie.length
			}
			return unescape(unsafeWindow.document.cookie.substring(deb,fin))
		}
		return "";
	}
	
	function setPhotoFailBlockerState(html) {
		var regEnabled = new RegExp("photo.*cach.?e.* +activ.?","gi");
		var regDisabled = new RegExp("photo.*cach.?e.* +d.?sactiv.?","gi");
		var regZone = new RegExp("/(-?[0-9]+)[^0123456789-](-?[0-9]+)","i");
		var filters = document.getElementById("filter").value;
		
		if(regEnabled.test(html))	pEnabled = true;
		if(regDisabled.test(html))	pEnabled = false;
		
		if(regZone.test(html)) {
			var matches = regZone.exec(html)
			var x = parseInt(matches[1])
			var y = parseInt(matches[2]);
			onDangerousZone = eval(filters);
		}
		if((!pEnabled && onDangerousZone) || filters.length == 0) {
			photoFailBlockerRef.style.display = "block";
		}else{
			photoFailBlockerRef.style.display = "none";
		}
	}
	
	function onChangeFilter(e) {
		setCookie("filters", document.getElementById("filter").value);
	}
	
	var blocker = unsafeWindow.document.getElementById(blockerId);
	if(getCookie(blockerId+"X") == "" || getCookie(blockerId+"Y") == "") {
		setCookie(blockerId+"X", 54);
		setCookie(blockerId+"Y", -321);
	}
	
	blocker.style.left = getCookie(blockerId + "X") + "px";
	blocker.style.top = getCookie(blockerId + "Y") + "px";
	unsafeWindow.document.getElementById("filter").value = getCookie("filters");
	/*unsafeWindow.document.getElementById("filter").onchange = onChangeFilter;
	unsafeWindow.document.getElementById("filter").onkeyup = onChangeFilter;*/
	unsafeWindow.document.getElementById("filter").addEventListener("keyup", onChangeFilter, true);
	unsafeWindow.document.getElementById("filter").addEventListener("change", onChangeFilter, true);
	
	function checkText() {
		setPhotoFailBlockerState(unsafeWindow.document.getElementById("infos").innerHTML);
	}
	
	function eventIsClean(e) {
		var targetTag = e.target.tagName;
		var keyCode = e.which;
		return targetTag != "TEXTAREA" && targetTag != "INPUT";
	}

	function keyHandler(e) {
		if (!eventIsClean(e)) return;
		var keyCode = e.which;
		//On CTRL+ALT+R, display the blocker and reset its content.
		if(keyCode == 114 && e.ctrlKey && e.altKey) {
			document.getElementById("filter").value = "";
			photoFailBlockerRef.style.display = "block";
		}
	}
	
	//unsafeWindow.document.onkeypress = keyHandler;
	unsafeWindow.document.addEventListener("keypress", keyHandler, true);
	window.setInterval(checkText, 50);
	
	/*
	//Doesn't works online :'(....
	unsafeWindow.setInfos = function(html) {
		setPhotoFailBlockerState(html);
		unsafeWindow._.fill(unsafeWindow._.get("infos"),html);
		unsafeWindow._.evaluateJS("infos");
		unsafeWindow.hideText();
	};/**/
}