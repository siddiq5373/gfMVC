<cfscript>
/*
CF7 way to create Array of Structure

EventConfig = ArrayNew(1);
eventInfo = StructNew();
eventInfo.event = 'foo.index';
eventInfo.parent = 'parentIndex';
eventInfo.listeners = 'fooListener.HandlerIndexEvent,fooListener.renderHomPage';
ArrayAppend(EventConfig, eventInfo);

*/

EventConfig = [
	{event='foo.index', securedEvent=false, parent='foo.parentIndex', listeners="fooListener.HandlerIndexEvent,fooListener.renderHomPage,fooListener.setLayoutandView"}
	,{event='foo.parentIndex', listeners="fooListener.HandlerIndexEvent,fooListener.renderHomPage"}
];
</cfscript>