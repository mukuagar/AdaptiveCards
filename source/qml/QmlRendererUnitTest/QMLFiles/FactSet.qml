import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
Rectangle{
id:adaptiveCard
readonly property int margins:12
implicitHeight:adaptiveCardLayout.implicitHeight
Layout.fillWidth:true
readonly property string bgColor:'#FFFFFF'
color:bgColor
clip:true
signal buttonClicked(var title, var type, var data)
function generateStretchHeight(childrens,minHeight){
var n = childrens.length
var implicitHt = 0;
var stretchCount = 0;
var stretchMinHeight = 0;
for(var i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator !== 'undefined')
{
implicitHt += childrens[i].height;
stretchMinHeight += childrens[i].height;
}
else
{
implicitHt += childrens[i].implicitHeight;
if(typeof childrens[i].stretch !== 'undefined')
{
stretchCount++;
}
else
{
stretchMinHeight += childrens[i].implicitHeight;
}
}
}
stretchMinHeight = (minHeight - stretchMinHeight)/stretchCount
for(i=0;(i<childrens.length);i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(typeof childrens[i].stretch !== 'undefined' && typeof childrens[i].minHeight !== 'undefined')
{
childrens[i].minHeight = Math.max(childrens[i].minHeight,stretchMinHeight)
}
}
}
if(stretchCount > 0 && implicitHt < minHeight)
{
var stretctHeight = (minHeight - implicitHt)/stretchCount
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(typeof childrens[i].stretch !== 'undefined')
{
childrens[i].height = childrens[i].implicitHeight + stretctHeight
}
}
}
}
else
{
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(typeof childrens[i].stretch !== 'undefined')
{
childrens[i].height = childrens[i].implicitHeight
}
}
}
}
}
function generateStretchWidth(childrens,width){
var implicitWid = 0
var autoWid = 0
var autoCount = 0
var weightSum = 0
var stretchCount = 0
var weightPresent = 0
for(var i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator !== 'undefined')
{
implicitWid += childrens[i].width
}
else
{
if(childrens[i].widthProperty.endsWith("px"))
{
childrens[i].width = parseInt(childrens[i].widthProperty.slice(0,-2))
implicitWid += childrens[i].width
}
else
{
if(childrens[i].widthProperty === "auto")
{
autoCount++
}
else if(childrens[i].widthProperty === "stretch")
{
stretchCount++
implicitWid += 50;
}
else
{
weightPresent = 1
weightSum += parseInt(childrens[i].widthProperty)
}
}
}
}
autoWid = (width - implicitWid)/(weightPresent + autoCount)
var flags = new Array(childrens.length).fill(0)
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(childrens[i].widthProperty === "auto")
{
if(childrens[i].minWidth < autoWid)
{
childrens[i].width = childrens[i].minWidth
implicitWid += childrens[i].width
flags[i] = 1;
autoCount--;
autoWid = (width - implicitWid)/(weightPresent + autoCount)
}
}
}
}
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(childrens[i].widthProperty === "auto")
{
if(flags[i] === 0)
{
childrens[i].width = autoWid
implicitWid += childrens[i].width
}
}
else if(childrens[i].widthProperty !== "stretch" && !childrens[i].widthProperty.endsWith("px"))
{
if(weightSum !== 0)
{
childrens[i].width = ((parseInt(childrens[i].widthProperty)/weightSum) * autoWid)
implicitWid += childrens[i].width
}
}
}
}
var stretchWidth = (width - implicitWid)/stretchCount
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(childrens[i].widthProperty === 'stretch')
{
childrens[i].width = 50+stretchWidth
}
}
}
}
function getMinWidth(childrens){
var min = 0
for(var j =0;j<childrens.length;j++)
{
if(typeof childrens[j].minWidth === 'undefined')
{
min = Math.max(min,Math.ceil(childrens[j].implicitWidth))
}
else
{
min = Math.max(min,Math.ceil(childrens[j].minWidth))
}
}
return min
}
function getMinWidthActionSet(childrens,spacing){
var min = 0
for(var j =0;j<childrens.length;j++)
{
min += Math.ceil(childrens[j].implicitWidth)
}
min += ((childrens.length - 1)*spacing)
return min
}
function getMinWidthFactSet(childrens, spacing){
var min = 0
for(var j=0;j<childrens.length;j+=2)
{
min = Math.max(min,childrens[j].implicitWidth + childrens[j+1].implicitWidth + spacing)
}
return min;
}
Frame{
id:adaptiveCard_frame
readonly property bool hasBackgroundImage:true
property var imgSource:"http://www.cisco.com/logo.png"
anchors.fill:parent
background:Image{
cache:false
source:parent.imgSource
fillMode:Image.PreserveAspectCrop
verticalAlignment:Qt.AlignTop
anchors.fill:parent
}

}
ColumnLayout{
id:adaptiveCardLayout
width:parent.width
Rectangle{
id:adaptiveCardRectangle
color:'transparent'
Layout.topMargin:margins
Layout.bottomMargin:margins
Layout.leftMargin:margins
Layout.rightMargin:margins
Layout.fillWidth:true
Layout.preferredHeight:bodyLayout.height
Layout.minimumHeight:1
Column{
id:bodyLayout
width:parent.width
onImplicitHeightChanged:{adaptiveCard.generateStretchHeight(children,-24)}
onImplicitWidthChanged:{adaptiveCard.generateStretchHeight(children,-24)}
GridLayout{
id:fs1
columns:2
rows:2
property int titleWidth:0
property int minWidth:adaptiveCard.getMinWidthFactSet(children, columnSpacing)
function setTitleWidth(item){	if (item.width > titleWidth){ titleWidth = item.width }}
Text{
width:parent.width
elide:Text.ElideRight
clip:true
textFormat:Text.MarkdownText
text:"Fact 1"
horizontalAlignment:Qt.AlignLeft
color:'#171B1F'
font.pixelSize:14
font.weight:Font.Bold
wrapMode:Text.Wrap
font.family:"Segoe UI"
Layout.maximumWidth:150
Component.onCompleted:parent.setTitleWidth(this)
}
Text{
width:parent.width
elide:Text.ElideRight
clip:true
textFormat:Text.MarkdownText
text:"Value 1"
horizontalAlignment:Qt.AlignLeft
color:'#171B1F'
font.pixelSize:14
font.weight:Font.Normal
wrapMode:Text.Wrap
font.family:"Segoe UI"
Layout.preferredWidth:parent.parent.width - parent.titleWidth
}
Text{
width:parent.width
elide:Text.ElideRight
clip:true
textFormat:Text.MarkdownText
text:"Fact 2"
horizontalAlignment:Qt.AlignLeft
color:'#171B1F'
font.pixelSize:14
font.weight:Font.Bold
wrapMode:Text.Wrap
font.family:"Segoe UI"
Layout.maximumWidth:150
Component.onCompleted:parent.setTitleWidth(this)
}
Text{
width:parent.width
elide:Text.ElideRight
clip:true
textFormat:Text.MarkdownText
text:"Value 2"
horizontalAlignment:Qt.AlignLeft
color:'#171B1F'
font.pixelSize:14
font.weight:Font.Normal
wrapMode:Text.Wrap
font.family:"Segoe UI"
Layout.preferredWidth:parent.parent.width - parent.titleWidth
}
}
Rectangle{
readonly property bool seperator:true
width:parent.width
height:4
color:"transparent"
visible:true
Rectangle{
width:parent.width
height:1
anchors.centerIn:parent
color:"#EEEEEE"
}
}
GridLayout{
id:fs2
columns:2
rows:2
property int titleWidth:0
property int minWidth:adaptiveCard.getMinWidthFactSet(children, columnSpacing)
readonly property bool stretch:true
function setTitleWidth(item){	if (item.width > titleWidth){ titleWidth = item.width }}
Text{
width:parent.width
elide:Text.ElideRight
clip:true
textFormat:Text.MarkdownText
text:"F1"
horizontalAlignment:Qt.AlignLeft
color:'#171B1F'
font.pixelSize:14
font.weight:Font.Bold
wrapMode:Text.Wrap
font.family:"Segoe UI"
Layout.maximumWidth:150
Component.onCompleted:parent.setTitleWidth(this)
}
Text{
width:parent.width
elide:Text.ElideRight
clip:true
textFormat:Text.MarkdownText
text:"V1"
horizontalAlignment:Qt.AlignLeft
color:'#171B1F'
font.pixelSize:14
font.weight:Font.Normal
wrapMode:Text.Wrap
font.family:"Segoe UI"
Layout.preferredWidth:parent.parent.width - parent.titleWidth
}
Text{
width:parent.width
elide:Text.ElideRight
clip:true
textFormat:Text.MarkdownText
text:"F2"
horizontalAlignment:Qt.AlignLeft
color:'#171B1F'
font.pixelSize:14
font.weight:Font.Bold
wrapMode:Text.Wrap
font.family:"Segoe UI"
Layout.maximumWidth:150
Component.onCompleted:parent.setTitleWidth(this)
}
Text{
width:parent.width
elide:Text.ElideRight
clip:true
textFormat:Text.MarkdownText
text:"V2"
horizontalAlignment:Qt.AlignLeft
color:'#171B1F'
font.pixelSize:14
font.weight:Font.Normal
wrapMode:Text.Wrap
font.family:"Segoe UI"
Layout.preferredWidth:parent.parent.width - parent.titleWidth
}
}
}
}
}
}
