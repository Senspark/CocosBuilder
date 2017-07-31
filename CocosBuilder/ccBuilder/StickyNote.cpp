/*
 * CocosBuilder: http://www.cocosbuilder.com
 *
 * Copyright (c) 2012 Zynga Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "StickyNote.h"
#include "CCBGlobals.h"

bool StickyNote::init() {
    if (not Super::init()) {
        return false;
    }

    setAnchorPoint(cocos2d::Vec2(0, 1));
    setIgnoreAnchorPointForPosition(false);

    bg_ = cocos2d::ui::Scale9Sprite::create("notes-bg.png");
    bg_->setAnchorPoint(cocos2d::Vec2(0, 0));
    bg_->setPosition(cocos2d::Point::ZERO);
    addChild(bg_, 0);

    lbl_ = cocos2d::Label::createWithTTF("Double click to edit",
                                         "MarkerFelt-Thin", 14);
    lbl_->setAnchorPoint(cocos2d::Vec2(0, 0));
    lbl_->setPosition(cocos2d::Point(kCCBNoteLblInsetH, kCCBNoteLblInsetBot));
    lbl_->setVerticalAlignment(cocos2d::TextVAlignment::TOP);
    lbl_->setHorizontalAlignment(cocos2d::TextHAlignment::LEFT);
    lbl_->setColor(cocos2d::Color3B(67, 49, 33));
    addChild(lbl_, 1);

    setContentSize(cocos2d::Size(kCCBNoteDefaultWidth, kCCBNoteDefaultHeight));
    return true;
}

void StickyNote::setContentSize(const cocos2d::Size& contentSize) {
    bg_->setContentSize(contentSize);

    CCLOG("set lbl.dimensions: (%f,%f)",
          contentSize.width - (2 * kCCBNoteLblInsetH),
          contentSize.height - kCCBNoteLblInsetTop - kCCBNoteLblInsetBot);

    lbl_->setDimensions(contentSize.width - (2 * kCCBNoteLblInsetH),
                        contentSize.height - kCCBNoteLblInsetTop -
                            kCCBNoteLblInsetBot);
    Super::setContentSize(contentSize);
}

void StickyNote::updatePos() {
    setPosition(CocosScene::getInstance()->convertToViewSpace(docPos_));
}

void StickyNote::setDocPos(const cocos2d::Point& p) {
    docPos_ = p;
    updatePos();
}

int StickyNote::hitAreaFromPt(const cocos2d::Point& pt) {
    auto localPt = convertToNodeSpace(pt);

    auto resizeRect = cocos2d::Rect(getContentSize().width - 22, 11, 16, 16);
    if (resizeRect.containsPoint(localPt)) {
        return kCCBStickyNoteHitResize;
    }

    auto noteRect = cocos2d::Rect(6, 11, getContentSize().width - 12,
                                  getContentSize().height - 18);
    if (noteRect.containsPoint(localPt)) {
        return kCCBStickyNoteHitNote;
    }

    return kCCBStickyNoteHitNone;
}

void StickyNote::setNoteText(const std::string& text) {
    noteText_ = text;
    if (noteText_.empty()) {
        lbl_->setString("Double click to edit");
    } else {
        lbl_->setString(noteText_);
    }
}

void StickyNote::setLabelVisible(bool labelVisible) {
    lbl_->setVisible(labelVisible);
}

bool StickyNote::labelVisible() const {
    return lbl_->isVisible();
}
