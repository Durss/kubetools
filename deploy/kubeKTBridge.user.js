// ==UserScript==
// @name          Kube bridge
// @namespace     http://fevermap.org/kubetools
// @include       http://kube.muxxu.com/
// @include       http://kube.muxxu.com/?*
// @description   Includes an LC SWF bridge to the kube game. This bridge provides communication between the game and the KubeTools application.
// ==/UserScript==

if (document.getElementById('swf_minimap') != null) {
	var swfRef, bridgeRef;
	bridgeRef= unsafeWindow.document.createElement('div');
	swfRef = unsafeWindow.document.getElementById('swf_minimap');
	swfRef.appendChild(bridgeRef);
	
	bridgeRef.innerHTML = '<embed type="application/x-shockwave-flash" src="http://fevermap.org/kubetools/lcBridge.swf?v=7" width="1" height="1" allowScriptAccess="always" quality="low" bgcolor="#ff0000" id="kubeBridge" /><div style="font-size:8px; position:relative; top:110px;">KB</div>';
}