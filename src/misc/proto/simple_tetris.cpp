#include <acllib.h>
#include <stdlib.h>
#include <iostream>
#include <time.h>
using namespace std;

//黑色 RGB值
#define BLACK RGB(0,0,0)
//定义单位像素的边长
#define step 10
//游戏窗体高度
#define boundaryH 20
//游戏窗体宽体
#define boundaryW 10
//俄罗斯方块形状的总数目（包括旋转后的）
#define Max_Shape 19

//窗体内已经存在的内容（重要，用于存放已经落下的俄罗斯方块的信息）
int WINDOW[boundaryH][boundaryW] = { 0 };

//旋转，向左/右移动的标志
bool isTransform = false;
bool isToLeft = false;
bool isToRight = false;
bool isGameOver = false;
bool isPause = false;

//俄罗斯方块形状编号num（重要全局变量，用于控制记录移动，形变以及边界是否碰撞） ， 用于记录定时器次数cnt
int num = 0, cnt = 0;

//分数
int score = 0;

//位置信息结构体
struct Pstruct {
	int  y, x;
};

//形状信息结构体
struct Sstruct {
	int shape[4][4];
	int next;//旋转一次后的形状
};

//每个形状的标准方向的编号，用于初始化生成随机俄罗斯方块使用
int seq[7] = { 0,2,6,10,12,14,15 };

//每个俄罗斯方块形状的图形数据（包括旋转后的），用4*4二维数组表示，心中有数即可，请直接略过
struct Sstruct SHAPE[19] = {
	//l
	{
	 0,1,0,0,
	 0,1,0,0,
	 0,1,0,0,
	 0,1,0,0,1
	}
	,
	//一
	{
		0,0,0,0,
		0,0,0,0,
		1,1,1,1,
		0,0,0,0,0
	}
	//L
	,{
		0,0,0,0,
		0,1,0,0,
		0,1,0,0,
		0,1,1,0,3

	}
	,
	{
		0,0,0,0,
		0,0,0,0,
		1,1,1,0,
		1,0,0,0,4
	}

	,{
		0,0,0,0,
		1,1,0,0,
		0,1,0,0,
		0,1,0,0,5

	}
	,
	{
		0,0,0,0,
		0,0,1,0,
		1,1,1,0,
		0,0,0,0,2
	}
	//rL
	,{
		0,0,0,0,
		0,1,0,0,
		0,1,0,0,
		1,1,0,0,7

	}
	,
	{
		0,0,0,0,
		1,0,0,0,
		1,1,1,0,
		0,0,0,0,8

	}

	,{
		0,0,0,0,
		0,1,1,0,
		0,1,0,0,
		0,1,0,0,9

	}

	,
	{
		0,0,0,0,
		0,0,0,0,
		1,1,1,0,
		0,0,1,0,6
	}
	//Z
	,
	{
		0,0,0,0,
		0,1,0,0,
		1,1,0,0,
		1,0,0,0,11
	}
	,
	{
		0,0,0,0,
		1,1,0,0,
		0,1,1,0,
		0,0,0,0,10
	}
	,
	//rZ
	{
		0,0,0,0,
		0,1,1,0,
		1,1,0,0,
		0,0,0,0,13
	}
	,
	{
		0,0,0,0,
		1,0,0,0,
		1,1,0,0,
		0,1,0,0,12
	}
	,
	//田
	{
		0, 0, 0, 0,
		1, 1, 0, 0,
		1, 1, 0, 0,
		0, 0, 0, 0,14
	}
	,
	//T
	{
		0, 0, 0, 0,
		0, 1, 0, 0,
		1, 1, 1, 0,
		0, 0, 0, 0,16
	}
	,
	{
		0,0,0,0,
		0,1,0,0,
		0,1,1,0,
		0,1,0,0,17
	}
	,
	{
		0, 0, 0, 0,
		0, 0, 0, 0,
		1, 1, 1, 0,
		0, 1, 0, 0,18
	}
	,
	{
		0,0, 0, 0,
		0,1, 0, 0,
		1,1, 0, 0,
		0,1, 0, 0,15
	}
};
//当前正在运动的俄罗斯方块的位置变量posi,(重要全局变量，用于控制记录方块移动，是否碰撞，4*4数组最左上角的位置)
struct Pstruct posi;

//俄罗斯方块生成函数
void initCube();
//定时器中断
void timeEvent(int tid);
//键盘中断
void keyEvent(int key, int event);

int Setup() {
	//生成窗口
	initWindow("Test", DEFAULT, DEFAULT, 380, 300);

	initCube();
	//注册定时器中断
	registerTimerEvent(timeEvent);
	//注册键盘中断
	registerKeyboardEvent(keyEvent);
	//开启定时器，50ms
	startTimer(0, 50);
	return 0;
}

void initCube() {
	//方块初始位置，游戏窗体的中点处
	posi = { 0,(boundaryW) / 2 + 5 };
	//srand生成随机因子，rand生成随机数
	srand((unsigned)time(NULL));
	num = seq[rand() % 7];
}

//定时器每中断一次重画一次游戏窗体，即每50ms重画一次
void picture_a_Cube() {
	beginPaint();
	//清屏
	clearDevice();
	//定义画笔、画刷为黑色
	setPenColor(BLACK);
	setBrushColor(BLACK);

	if (!isGameOver && !isPause) {
		//勾画游戏窗体边界
		line(50, 0, 50, boundaryH * step);
		line(50 + boundaryW * step, 0, 50 + boundaryW * step, boundaryH * step);
		line(50, boundaryH * step, 50 + boundaryW * step, boundaryH * step);

		//将WINDOW内存在的并且还未消除的俄罗斯方块画出
		for (int i = 0; i < boundaryH; i++) {
			for (int j = 0; j < boundaryW; j++) {
				if (WINDOW[i][j]) {
					rectangle((j + 5) * step, i * step, (j + 5 + 1) * step, (i + 1) * step);
				}
			}
		}
		//旋转
		if (isTransform) {
			isTransform = false;
			//temp用于存储原来的形状
			int temp = num;
			num = SHAPE[num].next;
			//判断是否可以进行旋转，如果旋转后的与原WINDOW内存在内容冲突则撤销
			bool isReach = false;
			for (int i = 0; i < 4; i++) {
				for (int j = 0; j < 4; j++) {
					if (SHAPE[num].shape[i][j]) {
						if (posi.y + i >= boundaryH || WINDOW[posi.y + i][posi.x - 5 + j]) {
							isReach = true;
							break;
						}
					}
				}
			}
			for (int i = 0; i < 4; i++)
				for (int j = 0; j < 4; j++) {
					if (SHAPE[num].shape[i][j]) {
						if (posi.x + j - 5 >= boundaryW || WINDOW[posi.y + i][posi.x - 5 + j] || posi.x + j - 5 < 0) {
							isReach = true;
							break;
						}
					}
				}
			//撤销
			if (isReach) num = temp;
		}
		//左移
		if (isToLeft) {
			isToLeft = false;
			bool isReach = false;
			//判断左移后是否冲突
			for (int i = 0; i < 4; i++)
				for (int j = 0; j < 4; j++) {
					if (SHAPE[num].shape[i][j]) {
						if (posi.x + j - 1 < 5 || WINDOW[posi.y + i][posi.x - 5 - 1 + j]) {
							isReach = true;
							break;
						}
					}
				}
			if (!isReach) posi.x--;

		}
		//右移
		if (isToRight) {
			isToRight = false;
			bool isReach = false;
			//判断是否冲突
			for (int i = 0; i < 4; i++)
				for (int j = 0; j < 4; j++) {
					if (SHAPE[num].shape[i][j]) {
						if (posi.x + j + 1 >= boundaryW + 5 || WINDOW[posi.y + i][posi.x - 5 + 1 + j]) {
							isReach = true;
							break;
						}
					}
				}
			if (!isReach) posi.x++;
		}
		//画出俄罗斯方块图形
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 4; j++) {
				if (SHAPE[num].shape[i][j]) {
					rectangle((j + posi.x) * step, (i + posi.y) * step, (j + 1 + posi.x) * step, (i + 1 + posi.y) * step);
				}
			}
		}

		//判断WINDOW数组是否存在某一行都存在方块，如果是则消除该行，并将之上的数据下移一行
		for (int i = 0; i < boundaryH; i++) {
			int count = 0;
			for (int j = 0; j < boundaryW; j++) {
				if (!WINDOW[i][j])break;
				count++;
			}
			if (count == boundaryW) {
				score += 10;
				for (int k = i - 1; k >= 0; k--) {
					for (int j = 0; j < boundaryW; j++) {
						WINDOW[k + 1][j] = WINDOW[k][j];
					}
				} 
				for (int j = 0; j < boundaryW; j++) WINDOW[0][j] = 0;
			}
		}
		char a[20] = "得分：";
		char sc[20];
		int i = 0;
		int sc_t = score;
		do {
			sc[i] = sc_t % 10 + '0';
			sc_t /= 10;
			i++;
		} while (sc_t != 0);
		int len = strlen(a);
		for (int j = 0; j < i; j++) {
			a[len + j] = sc[i - 1 - j];
		}
		paintText(250, 0, a);

	}
	else if(isGameOver){
		char a[40] = "Game Over";
		char b[40] = "Press Space to Restart";
		paintText(100, 0, a);
		paintText(100, 50, b);
		score = 0;
		memset(WINDOW, 0, sizeof(WINDOW));
	}
	else if (isPause) {
		char a[40] = "Pause";
		char b[40] = "Press Space to Resume";
		paintText(100, 0, a);
		paintText(100, 50, b);
	}
	endPaint();
}

void timeEvent(int tid) {
	if (!isPause) {
		cnt++;
	}
	//每隔50*5ms下降一个单位
	if (cnt >= 5) {
		cnt = 0;
		bool isReach = false;
		//判断是否可以下降
		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 4; j++) {
				if (SHAPE[num].shape[i][j]) {//对于形状中的每一块
					if (posi.y + i + 1 >= boundaryH || WINDOW[posi.y + i + 1][posi.x - 5 + j]) {
						isReach = true;
						break;
					}
				}
			}
			if (isReach) {
				break;
			}
		}

		if (!isReach) posi.y++;
		else { //方块落地/障碍
			for (int i = 0; i < 4; i++) {
				for (int j = 0; j < 4; j++) {
					if (SHAPE[num].shape[i][j]) {
						WINDOW[posi.y + i][posi.x - 5 + j] = 1;
					}
				}
			}
			if (posi.y == 0) {
				isGameOver = true;
			}
			initCube();
		}
	}
	//重绘游戏窗体
	picture_a_Cube();
}
void keyEvent(int key, int event) {
	//形变
	if (key == VK_UP) {
		if (event == KEY_UP) {
			isTransform = true;
		}
	}
	//左移
	if (key == VK_LEFT) {
		if (event == KEY_DOWN) {
			isToLeft = true;
		}
	}
	//右移
	if (key == VK_RIGHT) {
		if (event == KEY_DOWN) {
			isToRight = true;
		}
	}
	//加速下降，50ms改为10ms
	if (key == VK_DOWN) {
		if (event == KEY_DOWN) {
			startTimer(0, 10);
		}
		else if (event == KEY_UP) {
			startTimer(0, 50);
		}
	}
	//暂停
	if (key == VK_SPACE) {
		if (event == KEY_DOWN && isGameOver) {
			isGameOver = false;
		}
		else if (event == KEY_DOWN && isPause) {
			isPause = false;
		}
		else if (event == KEY_DOWN && !isPause) {
			isPause = true;
		}
	}
}