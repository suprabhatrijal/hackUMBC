import logo from './logo.svg';
import './App.css';
import {React, useRef, useState, useEffect} from 'react'

function App() {

  const canvasRef = useRef(null)
  const contextRef = useRef(null)
  const [isDrawing, setIsDrawing] = useState()

  useEffect(() => {
    const canvas = canvasRef.current
    canvas.width = window.innerWidth 
    canvas.height = window.innerHeight 
    canvas.style.width = `${window.innerWidth }px`
    canvas.style.height =`${window.innerHeight }px`


    const context = canvas.getContext('2d')

    context.scale(1,1)
    context.lineCap ="round"
    context.strokeStyle = "black"
    context.lineWidth = 2

    contextRef.current = context
  },[])

  const startDrawing = ({nativeEvent}) => {
    const {offsetX, offsetY} = nativeEvent

    contextRef.current.beginPath()
    contextRef.current.moveTo(offsetX, offsetY)
    setIsDrawing(true)
    
  }

  const startDrawingTouch = ({nativeEvent}) => {
    const touches = nativeEvent.touches[0]
    const offsetX = touches.clientX
    const offsetY = touches.clientY

    contextRef.current.beginPath()
    contextRef.current.moveTo(offsetX, offsetY)
    setIsDrawing(true)
    
  }
  const endDrawing = () => {
    contextRef.current.closePath()
    setIsDrawing(false)
  }

  const draw = ({nativeEvent}) => {
    if (!isDrawing) {
      return
    }
    const {offsetX, offsetY} = nativeEvent
    contextRef.current.lineTo(offsetX, offsetY)
    contextRef.current.stroke()
  }
  const drawTouch = ({nativeEvent}) => {
    if (!isDrawing) {
      return
    }
    const offsetX = nativeEvent.touches[0].clientX
    const offsetY = nativeEvent.touches[0].clientY
    contextRef.current.lineTo(offsetX, offsetY)
    contextRef.current.stroke()
  }
  return (
    <div className="Canvas">
      <canvas
        ref={canvasRef}
        onMouseDown={startDrawing}
        onMouseUp={endDrawing}
        onMouseMove={draw}
        onTouchStart={startDrawingTouch}
        onTouchEnd={endDrawing}
        onTouchMove={drawTouch}
      />
      
    </div>
  );
}

export default App;
