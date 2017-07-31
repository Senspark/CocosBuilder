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

#include "RulersLayer.h"
#import "CCBGlobals.h"

#define kCCBRulerWidth 15

bool RulersLayer::init() {
    if (not Super::init()) {
        return false;
    }

    bgVertical_ = cocos2d::ui::Scale9Sprite::create("ruler-bg-vertical.png");
    bgVertical_->setAnchorPoint(cocos2d::Vec2::ANCHOR_BOTTOM_LEFT);

    bgHorizontal_ =
        cocos2d::ui::Scale9Sprite::create("ruler-bg-horizontal.png");
    bgHorizontal_->setAnchorPoint(cocos2d::Vec2::ANCHOR_BOTTOM_LEFT);

    addChild(bgVertical_);
    addChild(bgHorizontal_, 2);

    marksVertical_ = cocos2d::Node::create();
    marksHorizontal_ = cocos2d::Node::create();
    addChild(marksVertical_, 1);
    addChild(marksHorizontal_, 3);

    mouseMarkVertical_ = cocos2d::Sprite::create("ruler-guide.png");
    mouseMarkVertical_->setAnchorPoint(cocos2d::Vec2::ANCHOR_BOTTOM_LEFT);
    mouseMarkVertical_->setVisible(false);
    addChild(mouseMarkVertical_, 4);

    mouseMarkHorizontal_ = cocos2d::Sprite::create("ruler-guide.png");
    mouseMarkHorizontal_->setRotation(-90);
    mouseMarkHorizontal_->setAnchorPoint(cocos2d::Vec2::ANCHOR_MIDDLE_LEFT);
    mouseMarkHorizontal_->setVisible(false);
    addChild(mouseMarkHorizontal_, 4);

    auto xyBg = cocos2d::Sprite::create("ruler-xy.png");
    addChild(xyBg, 5);
    xyBg->setAnchorPoint(cocos2d::Vec2::ANCHOR_BOTTOM_LEFT);
    xyBg->setPosition(cocos2d::Point::ZERO);

    lblX_ = cocos2d::Label::createWithCharMap("ruler-numbers.png", 6, 8, '-');
    lblX_->setString("0");
    lblX_->setAnchorPoint(cocos2d::Vec2::ANCHOR_BOTTOM_RIGHT);
    lblX_->setPosition(cocos2d::Point(47, 3));
    lblX_->setVisible(false);
    addChild(lblX_, 6);

    lblY_ = cocos2d::Label::createWithCharMap("ruler-numbers.png", 6, 8, '-');
    lblY_->setString("0");
    lblY_->setAnchorPoint(cocos2d::Vec2::ANCHOR_BOTTOM_RIGHT);
    lblY_->setPosition(cocos2d::Point(97, 3));
    lblY_->setVisible(false);
    addChild(lblY_, 6);
    // lblY = [CCLabelAtlas labelWithString:@"0"
    // charMapFile:@"ruler-numbers.png" itemWidth:6 itemHeight:8
    // startCharMap:'0'];
    return true;
}

void RulersLayer::updateWithSize(const cocos2d::Size& ws,
                                 const cocos2d::Point& so, float zm) {
    stageOrigin_.x = (int)stageOrigin_.x;
    stageOrigin_.y = (int)stageOrigin_.y;

    if (ws.equals(winSize_) && so.equals(stageOrigin_) && zm == zoom_) {
        return;
    }

    // Store values
    winSize_ = ws;
    stageOrigin_ = so;
    zoom_ = zm;

    // Resize backrounds
    bgHorizontal_->setContentSize(
        cocos2d::Size(winSize_.width, kCCBRulerWidth));
    bgVertical_->setContentSize(cocos2d::Size(kCCBRulerWidth, winSize_.height));

    // Add marks and numbers
    marksVertical_->removeAllChildrenWithCleanup(true);
    marksHorizontal_->removeAllChildrenWithCleanup(true);

    // Vertical marks
    int y = (int)so.y - (((int)so.y) / 10) * 10;
    while (y < winSize_.height) {
        int yDist = std::abs(y - (int)stageOrigin_.y);

        cocos2d::Sprite* mark = nullptr;
        bool addLabel = false;
        if (yDist == 0) {
            mark = cocos2d::Sprite::create("ruler-mark-origin.png");
            addLabel = true;
        } else if (yDist % 50 == 0) {
            mark = cocos2d::Sprite::create("ruler-mark-major.png");
            addLabel = true;
        } else {
            mark = cocos2d::Sprite::create("ruler-mark-minor.png");
        }
        mark->setAnchorPoint(cocos2d::Vec2::ANCHOR_MIDDLE_LEFT);
        mark->setPosition(cocos2d::Point(0, y));
        marksVertical_->addChild(mark);

        if (addLabel) {
            int displayDist = yDist / zoom_;
            auto str = cocos2d::StringUtils::format("%d", displayDist);
            int strLen = str.size();

            for (int i = 0; i < strLen; i++) {
                std::string ch(1, str[i]);
                auto lbl = cocos2d::Label::createWithCharMap(
                    "ruler-numbers.png", 6, 8, '-');
                lbl->setString(ch);
                lbl->setAnchorPoint(cocos2d::Vec2::ANCHOR_BOTTOM_LEFT);
                lbl->setPosition(
                    cocos2d::Point(2, y + 1 + 8 * (strLen - i - 1)));
                marksVertical_->addChild(lbl, 1);
            }
        }
        y += 10;
    }

    // Horizontal marks
    int x = (int)so.x - (((int)so.x) / 10) * 10;
    while (x < winSize_.width) {
        int xDist = std::abs(x - (int)stageOrigin._x);

        cocos2d::Sprite* mark = nullptr;
        bool addLabel = false;
        if (xDist == 0) {
            mark = cocos2d::Sprite::create("ruler-mark-origin.png");
            addLabel = true;
        } else if (xDist % 50 == 0) {
            mark = cocos2d::Sprite::create("ruler-mark-major.png");
            addLabel = true;
        } else {
            mark = cocos2d::Sprite::create("ruler-mark-minor.png");
        }
        mark->anchorPoint(cocos2d::Vec2(0, 0.5f));
        mark->setPosition(cocos2d::Point(x, 0));
        mark->setRotation(-90);
        marksHorizontal_->addChild(mark);

        if (addLabel) {
            int displayDist = xDist / zoom_;
            auto str = cocos2d::StringUtils::format("%d", displayDist);

            auto lbl = cocos2d::Label::createWithCharMap("ruler-numbers.png", 6,
                                                         8, '-');
            lbl->setString(str);
            lbl->setAnchorPoint(cocos2d::Vec2(0, 0));
            lbl->setPosition(cocos2d::Point(x + 1, 1));
            marksHorizontal_->addChild(lbl, 1);
        }
        x += 10;
    }
}

void RulersLayer::updateMousePos(const cocos2d::Point& pos) {
    mouseMarkHorizontal_->setPosition(cocos2d::Point(pos.x, 0));
    mouseMarkVertical_->setPosition(cocos2d::Point(0, pos.y));

    auto cs = CocosScene::getInstance();
    auto docPos = cs->convertToDocSpace(pos);
    lblX_->setString(cocos2d::StringUtils::format("%d", (int)docPos.x));
    lblY_->setString(cocos2d::StringUtils::format("%d", (int)docPos.y));
}

void RulersLayer::mouseEntered() {
    mouseMarkHorizontal_->setVisible(true);
    mouseMarkVertical_->setVisible(true);
    lblX_->setVisible(true);
    lblY_->setVisible(true);
}

void RulersLayer::mouseExited() {
    mouseMarkHorizontal_->setVisible(false);
    mouseMarkVertical_->setVisible(false);
    lblX_->setVisible(false);
    lblY_->setVisible(false);
}
