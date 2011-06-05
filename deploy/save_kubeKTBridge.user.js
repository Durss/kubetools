// ==UserScript==
// @name          Kube bridge
// @namespace     http://www.muxxu.free.fr/kube/apps/kubetools
// @include       http://kube.muxxu.com/
// @include       http://kube.muxxu.com/?*
// @description   Includes an LC SWF bridge to the kube game
// ==/UserScript==

if (document.getElementById('swf_minimap') != null) {
	var swfRef, bridgeRef, photoFailBlockerRef;
	swfRef = unsafeWindow.document.getElementById('mxcontent');
	
	photoFailBlockerRef= unsafeWindow.document.createElement('div');
	bridgeRef= unsafeWindow.document.createElement('div');
	swfRef.parentNode.insertBefore(photoFailBlockerRef, swfRef.nextSibling);
	swfRef.parentNode.insertBefore(bridgeRef, swfRef.nextSibling);
	
	bridgeRef.innerHTML = '<embed type="application/x-shockwave-flash" src="http://www.muxxu.free.fr/kube/apps/kubetools/lcBridge.swf?v=6" width="1" height="1" allowScriptAccess="always" quality="low" bgcolor="#ff0000" id="kubeBridge" /><div style="font-size:8px; margin-top:-70px; margin-left:55px; position:relative;">KB</div>';
	
	photoFailBlockerRef.innerHTML = "<div style=\"position: relative; z-index: 5; left: 10px; top: 10px; width: 47px; height: 50px; background-color: rgb(0, 0, 0); background-image: url('http://www.muxxu.free.fr/kube/images/noPhoto.jpg'); background-repeat: no-repeat; background-position: left top;\" id=\"photoFailBlocker\"><a style=\"font-size:10px; cursor:pointer; margin-left:10px;\" id=\"resetPosLink\">RESET</a></div>";

	var dragObject  = null;
	var mouseOffset = null;
	
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
	
	function getMouseOffset(target, event){
		event = event || window.event;

		var docPos    = getPosition(target);
		var mousePos  = mouseCoords(event);
		return {x:mousePos.x - docPos.x, y:mousePos.y - docPos.y};
	}
	
	function getPosition(e){
		var left = 0;
		var top  = 0;

		while (e.offsetParent){
			left += e.offsetLeft;
			top  += e.offsetTop;
			e     = e.offsetParent;
		}

		left += e.offsetLeft;
		top  += e.offsetTop;

		return {x:left, y:top};
	}
	
	function mouseMove(event){
		event			= event || window.event;
		var mousePos	= mouseCoords(event);

		if(dragObject){
			//dragObject.style.position = 'absolute';
			var pos = getPosition(dragObject.parentNode);
			var px = mousePos.x - mouseOffset.x - pos.x;
			var py = mousePos.y - mouseOffset.y - pos.y;
			dragObject.style.left     = px+"px";
			dragObject.style.top      = py+"px";
			setCookie(dragObject.id+"X", px);
			setCookie(dragObject.id+"Y", py);
			return false;
		}
	}
	
	function mouseCoords(event){
		if(event.pageX || event.pageY){
			return {x:event.pageX, y:event.pageY};
		}
		return {
			x:event.clientX + unsafeWindow.document.body.scrollLeft - unsafeWindow.document.body.clientLeft,
			y:event.clientY + unsafeWindow.document.body.scrollTop  - unsafeWindow.document.body.clientTop
		};
	}
	
	function mouseUp(){
		dragObject = null;
	}
	
	function makeDraggable(item){
		if(!item) return;
		item.onmousedown = function(event){
			dragObject  = this;
			mouseOffset = getMouseOffset(this, event);
			return false;
		}
		
		if(getCookie(item.id+"X") == "" || getCookie(item.id+"Y") == "") {
			setCookie(item.id+"X", 108);
			setCookie(item.id+"Y", -367);
		}
		
		item.style.left = getCookie(item.id+"X") + "px";
		item.style.top = getCookie(item.id+"Y") + "px";
	}
	
	function resetPosition() {
		item = unsafeWindow.document.getElementById("photoFailBlocker");
		setCookie(item.id+"X", 108);
		setCookie(item.id+"Y", -367);
		item.style.left = getCookie(item.id+"X") + "px";
		item.style.top = getCookie(item.id+"Y") + "px";
		dragObject = null;
	}
	
	makeDraggable(unsafeWindow.document.getElementById("photoFailBlocker"));
	
	unsafeWindow.document.onmousemove = mouseMove;
	unsafeWindow.document.onmouseup   = mouseUp;
	unsafeWindow.document.getElementById("resetPosLink").onmouseup   = resetPosition;
}