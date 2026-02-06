document.querySelectorAll('[data-count]').forEach(el=>{
  let t=0,max=+el.dataset.count
  let i=setInterval(()=>{
    t++; el.textContent=t
    if(t>=max) clearInterval(i)
  },20)
})

document.addEventListener('mousemove',e=>{
  const h=document.querySelector('.hero-3d')
  h.style.transform=`rotateY(${e.clientX/40}deg) rotateX(${-e.clientY/40}deg)`
})
