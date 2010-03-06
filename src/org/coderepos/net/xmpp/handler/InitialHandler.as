package org.coderepos.net.xmpp.handler
{
    import org.coderepos.xml.sax.XMLElementEventHandler;
    import org.coderepos.xml.XMLElement;
    import org.coderepos.xml.XMLAttributes;

    import org.coderepos.net.xmpp.XMPPStream;
    import org.coderepos.net.xmpp.XMPPServerFeatures;
    import org.coderepos.net.xmpp.XMPPNamespace;
    import org.coderepos.net.xmpp.exceptions.XMPPProtocolError;

    public class InitialHandler implements IXMPPStreamHandler
    {
        private var _stream:XMPPStream;

        public function InitialHandler(stream:XMPPStream)
        {
            _stream = stream;
        }

        public function run():void
        {
            _stream.setXMLEventHandler(getHandler());
            _stream.send(
            //'<?xml version="1.0" encoding="utf-8"?>'
            '<stream:stream '
            +   'xmlns="' + XMPPNamespace.CLIENT + '" '
            +   'xmlns:stream="' + XMPPNamespace.STREAM + '" '
            +   'to="' + _stream.domain + '" '
            +   'version="1.0">'
            );
        }

        protected function getHandler():XMLElementEventHandler
        {
            var handler:XMLElementEventHandler = new XMLElementEventHandler();
            handler.registerRootElementAttributeEvent(
                XMPPNamespace.STREAM, "stream", streamHandler);
            handler.registerElementEvent(
                XMPPNamespace.STREAM, "features", 1, featuresHandler);
            handler.registerElementEvent(
                XMPPNamespace.STREAM, "error", 1, errorHandler);
            handler.registerUnknownElementEvent(unknownHandler);
            return handler;
        }

        private function streamHandler(attrs:XMLAttributes):void
        {
            trace("[STREAM]");
            var id:String = attrs.getValue("id");
            if (id == null)
                throw new XMPPProtocolError("stream@id not found");
            var version:String = attrs.getValue("version");
            if (version == null)
                throw new XMPPProtocolError("stream@version not found");
            if (version != "1.0")
                throw new XMPPProtocolError("Unsupported XMPP protocol version: " + version);
            _stream.setAttribute("id", id);
            _stream.setAttribute("version", version);
        }

        private function featuresHandler(elem:XMLElement):void
        {
            trace("[FEATURES]");
            _stream.features = XMPPServerFeatures.fromElement(elem);
            _stream.initiated();
        }

        private function errorHandler(elem:XMLElement):void
        {
            trace("[ERROR]");
            throw new XMPPProtocolError("failed to initiate stream");
        }

        private function unknownHandler(ns:String, localName:String, depth:uint):void
        {
            trace("[UNKNOWN]");
            trace(ns);
            trace(localName);
        }
    }
}

