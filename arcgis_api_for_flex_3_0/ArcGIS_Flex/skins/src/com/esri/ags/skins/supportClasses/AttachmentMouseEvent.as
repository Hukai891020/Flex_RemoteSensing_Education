/*
   Copyright (c) 2010 ESRI

   All rights reserved under the copyright laws of the United States
   and applicable international laws, treaties, and conventions.

   You may freely redistribute and use this sample code, with or
   without modification, provided you include the original copyright
   notice and use restrictions.

   See use restrictions in use_restrictions.txt.
 */
package com.esri.ags.skins.supportClasses
{

import com.esri.ags.layers.supportClasses.AttachmentInfo;

import flash.events.Event;
import flash.events.MouseEvent;

/**
 * Represents event objects that are specific to attachments.
 * Specifically if a user clicks or double clicks on an attachment in the attachment inspector.
 *
 * @private
 */
public class AttachmentMouseEvent extends MouseEvent
{
    /**
     * Defines the value of the <code>type</code> property of the event object for an attachmentClick event.
     * @eventType attachmentClick
     */
    public static const ATTACHMENT_CLICK:String = "attachmentClick";

    /**
     * Defines the value of the <code>type</code> property of the event object for an attachmentDoubleClick event.
     * @eventType attachmentDoubleClick
     */
    public static const ATTACHMENT_DOUBLE_CLICK:String = "attachmentDoubleClick";

    /**
     * Reference to the associated attachment info.
     */
    public var attachmentInfo:AttachmentInfo;

    private var m_mouseEvent:MouseEvent;

    /**
     * Creates a new AttachmentMouseEvent.
     * Note that this is a bubbling event.
     *
     * @param type The event type; indicates the action that triggered the event.
     * @param attachmentInfo Reference to an attachment info.
     */
    public function AttachmentMouseEvent(type:String, attachmentInfo:AttachmentInfo)
    {
        super(type, true);
        this.attachmentInfo = attachmentInfo;
    }

    /**
     * @private
     */
    override public function clone():Event
    {
        const event:AttachmentMouseEvent = new AttachmentMouseEvent(type, attachmentInfo);
        event.copyProperties(m_mouseEvent);
        return event;
    }

    /**
     * @private
     */
    public function copyProperties(mouseEvent:MouseEvent):void
    {
        localX = mouseEvent.localX;
        localY = mouseEvent.localY;
        relatedObject = mouseEvent.relatedObject;
        ctrlKey = mouseEvent.ctrlKey;
        altKey = mouseEvent.altKey;
        shiftKey = mouseEvent.shiftKey;
        buttonDown = mouseEvent.buttonDown;
        delta = mouseEvent.delta;

        m_mouseEvent = mouseEvent; // save for stageX/Y and clone()
    }

    /**
     * @private
     */
    override public function get stageX():Number
    {
        return m_mouseEvent.stageX;
    }

    /**
     * @private
     */
    override public function get stageY():Number
    {
        return m_mouseEvent.stageY;
    }

    /**
     * @private
     */
    override public function toString():String
    {
        return formatToString("AttachmentMouseEvent", "type", "attachmentInfo", "localX", "localY", "stageX", "stageY", "relatedObject", "ctrlKey", "altKey", "shiftKey", "delta");
    }
}

}
