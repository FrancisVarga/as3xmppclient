package org.coderepos.net.xmpp
{
    import org.coderepos.xml.XMLElement;

    public class XMPPServerFeatures
    {
        public static function fromElement(elem:XMLElement):XMPPServerFeatures
        {
            var features:XMPPServerFeatures = new XMPPServerFeatures();

            var startTLS:XMLElement =
                elem.getFirstElementNS(XMPPNamespace.TLS, "starttls");
            if (startTLS != null) {
                //startTLS.getFirstElement("required");
                //startTLS.getFirstElement("optional");
                features.supportTLS = true;
            }

            var mechanisms:XMLElement =
                elem.getFirstElementNS(XMPPNamespace.SASL, "mechanisms");
            if (mechanisms != null) {
                var mechArray:Array = mechanisms.getElements("mechanism");
                for each(var mech:XMLElement in mechArray)
                    features.addSASLMechanism(mech.text);
            }

            var auth:XMLElement =
                elem.getFirstElementNS(XMPPNamespace.FEATURE_AUTH, "auth");
            if (auth != null) {
                features.supportNonSASLAuth = true;
            }

            var bind:XMLElement =
                elem.getFirstElementNS(XMPPNamespace.BIND, "bind");
            if (bind != null) {
                //bind.getFirstElement("required");
                //bind.getFirstElement("optional");
                features.supportResourceBinding = true;
            }

            var session:XMLElement =
                elem.getFirstElementNS(XMPPNamespace.SESSION, "session");
            if (session != null) {
                features.supportSession = true;
            }

            var compress:XMLElement =
                elem.getFirstElementNS(XMPPNamespace.FEATURE_COMPRESS, "compression");
            if (compress != null) {
                var compMethods:Array = compress.getElements("method");
                for each(var meth:XMLElement in compMethods)
                    features.addCompressionMethod(meth.text);
            }
            return features;
        }

        private var _saslMechs:Array;
        private var _compMethods:Array;
        public var supportTLS:Boolean;
        public var supportSession:Boolean;
        public var supportResourceBinding:Boolean;
        public var supportNonSASLAuth:Boolean;

        public function XMPPServerFeatures()
        {
            _saslMechs             = [];
            _compMethods           = [];
            supportTLS             = false;
            supportSession         = false;
            supportResourceBinding = false;
            supportNonSASLAuth     = false;
        }

        public function get supportSASL():Boolean
        {
            return (_saslMechs.length > 0);
        }

        public function addSASLMechanism(mechName:String):void
        {
            _saslMechs.push(mechName);
        }

        public function get saslMechs():Array
        {
            return _saslMechs;
        }

        public function get supportCompression():Boolean
        {
            return (_compMethods.length > 0);
        }

        public function addCompressionMethod(meth:String):void
        {
            _compMethods.push(meth);
        }
    }
}

