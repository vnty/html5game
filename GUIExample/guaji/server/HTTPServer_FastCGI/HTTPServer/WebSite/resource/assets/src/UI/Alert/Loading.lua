local Loading = {
    
}
function Loading:create()
    self.ui = ui_delegate(ccs.GUIReader:getInstance():widgetFromJsonFile("res/ui/alert-loading.json"))
    return self.ui
end

function Loading:onShow(label)
    if(label)then
        self.ui.lbl_msg:setString(label)
    end
    local r = cc.RotateBy:create(1,360)
    self.ui.img_circle:runAction(cc.RepeatForever:create(r))
end
return Loading