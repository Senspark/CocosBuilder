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

#include <cocos2d.h>
#include <ui/UIScale9Sprite.h>

class RulersLayer : public cocos2d::Layer {
private:
    using Super = cocos2d::Layer;

public:
    void updateWithSize(const cocos2d::Size& winSize,
                        const cocos2d::Point& stageOrigin, float zoom);

    void mouseEntered();

    void mouseExited();

    void updateMousePos(const cocos2d::Point& pos);

protected:
    virtual bool init() override;

private:
    cocos2d::ui::Scale9Sprite* bgHorizontal_;
    cocos2d::ui::Scale9Sprite* bgVertical_;

    cocos2d::Node* marksVertical_;
    cocos2d::Node* marksHorizontal_;

    cocos2d::Sprite* mouseMarkHorizontal_;
    cocos2d::Sprite* mouseMarkVertical_;

    cocos2d::Size winSize_;
    cocos2d::Point stageOrigin_;
    float zoom_;

    cocos2d::Label* lblX_;
    cocos2d::Label* lblY_;
};
